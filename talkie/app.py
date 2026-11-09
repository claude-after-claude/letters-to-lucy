"""talkie-1930-13b-base on a Modal GPU, scale to zero. No web endpoint: nothing can start it by polling.

    env -u MODAL_TOKEN_ID modal run talkie/app.py::download [--which web]   # once per model, CPU only
    env -u MODAL_TOKEN_ID modal deploy talkie/app.py
    talkie/say.py "The effects of the wireless upon the young have"

The volume `talkie-1930` holds ~26 GB per model (about $2.40 a month each). Delete it when nobody uses this any more.
"""
import modal

REPOS = {"1930": "xlr8harder/talkie-1930-13b-base-tf",   # pre-1931 text
         "web": "xlr8harder/talkie-web-13b-base-tf"}     # the twin: same architecture, modern web text
CACHE = "/cache"

app = modal.App("talkie-1930")
vol = modal.Volume.from_name("talkie-1930", create_if_missing=True)
image = (
    modal.Image.debian_slim(python_version="3.12")
    .pip_install("torch", "transformers==5.8.0", "safetensors", "tiktoken", "accelerate",
                 "huggingface_hub[hf_transfer]")
    .env({"HF_HOME": CACHE, "HF_HUB_ENABLE_HF_TRANSFER": "1"})
)


@app.function(image=image, volumes={CACHE: vol}, timeout=60 * 60)
def download(which: str = "1930"):
    from huggingface_hub import snapshot_download
    path = snapshot_download(REPOS[which])
    vol.commit()
    print("downloaded to", path)


@app.cls(image=image, volumes={CACHE: vol}, gpu="L40S", scaledown_window=240, max_containers=1,
         timeout=20 * 60)
class Talkie:
    which: str = modal.parameter(default="1930")

    @modal.enter()
    def load(self):
        REPO = REPOS[self.which]
        import torch
        from transformers import AutoModelForCausalLM, AutoTokenizer
        self.tok = AutoTokenizer.from_pretrained(REPO, trust_remote_code=True)
        self.model, self.loading_info = AutoModelForCausalLM.from_pretrained(
            REPO, trust_remote_code=True, dtype=torch.bfloat16, device_map={"": "cuda"},
            use_safetensors=True, output_loading_info=True)
        self.model.eval()
        print("talkie loaded", {k: len(v) for k, v in self.loading_info.items()})

    @modal.method()
    def debug(self, prompt: str) -> str:
        import traceback
        try:
            return self._debug(prompt)
        except Exception:
            return traceback.format_exc()

    def _debug(self, prompt: str) -> str:
        """What loaded, and what the bare forward pass (no generate, no cache) predicts."""
        import torch
        import transformers
        ids = self.tok(prompt, return_tensors="pt").input_ids.to("cuda")
        with torch.no_grad():
            logits = self.model(ids).logits.float()
        logp = torch.log_softmax(logits[0], -1)
        nll = -logp[:-1].gather(1, ids[0, 1:, None]).mean().item()
        top = logp[-1].topk(10)
        import json
        return json.dumps({
            "transformers": transformers.__version__, "torch": torch.__version__,
            "loading_info": {k: list(v)[:8] if not isinstance(v, dict) else list(v)[:8] for k, v in self.loading_info.items()},
            "n_tokens": ids.shape[1], "ids_head": ids[0, :12].tolist(),
            "roundtrip": self.tok.decode(ids[0]) == prompt,
            "mean_nll_nats": nll,
            "top10": [(self.tok.decode([i]), round(v, 2)) for v, i in zip(top.values.tolist(), top.indices.tolist())],
            "param_dtype": str(next(self.model.parameters()).dtype),
        }, default=str, ensure_ascii=False, indent=1)

    @modal.method()
    def generate(self, prompt: str, n: int = 1, max_new_tokens: int = 300, temperature: float = 0.9,
                 top_p: float = 0.95, stop: list[str] | None = None) -> list[str]:
        import torch
        ids = self.tok(prompt, return_tensors="pt").input_ids.to("cuda")
        assert ids.shape[1] + max_new_tokens <= 4096, f"prompt is {ids.shape[1]} tokens; context is 4096"
        out = []
        for _ in range(n):  # one at a time: the remote code's batching with padding is untested
            with torch.no_grad():
                gen = self.model.generate(ids, max_new_tokens=max_new_tokens, do_sample=True,
                                          temperature=temperature, top_p=top_p)
            text = self.tok.decode(gen[0, ids.shape[1]:], skip_special_tokens=True)
            for s in stop or []:
                if s in text:
                    text = text[: text.index(s)]
            out.append(text)
        return out
