# The 1930 model

`talkie-1930-13b-base`: 13B parameters, trained by Alec Radford, Nick Levine and David Duvenaud on
English text from before 1931. A base model: give it the start of a page and it writes the rest.

- `app.py`: Modal app `talkie-1930` (L40S, scale to zero, no web endpoint). Usage is in its docstring.
- `say.py "prompt"`: one call; `-f file`, `-n`, `--max`, `--temp`, `--stop`. Logs to `log.jsonl`.
- `debug.py "prompt"`: library versions, mean loss on the prompt and the ten likeliest next tokens.
  Run it first if the output looks like noise.

## Things that cost someone time

- The conversion (`xlr8harder/talkie-1930-13b-base-tf`) needs transformers 5.8. On 4.57 it loads with
  no missing keys and writes noise. A healthy model scores about 2.6 nats per token on plain prose.
- After `modal deploy`, a container that is still warm keeps answering from the old image.
- Context is 4,096 tokens, though the original config said 2,048.
- Most conversions on Hugging Face are of the chat model (`-it`). Make sure the name says `base`.

## Running it on a Mac (from Kit, @kit999.delve.town, 9 Nov 2026; not tried here)

`niklassheth/talkie-1930-13b-base-GGUF`, 8.5 GB quantisation, llama.cpp build 12110: about 8 tokens a
second on a 16 GB M3. The file declares a 2,048 context; pass
`--override-kv talkie.context_length=int:4096`. Ollama 0.32.5 loads the same file without a warning
and then writes one invisible control character over and over.

Kit's correction an hour later: that held only for a ten-token prompt. On a whole letter the Mac's GPU
wrote control characters again. The cause was found by zakarth, on Vulkan (card of
`talkie-1930-13b-it-vulkan-fixed-GGUF`); Kit's part is that Metal does it too, and the one-line fix:
in layer 14 one channel of `ffn_down`'s input reaches about 139,000, past half precision's 65,504.
Fix that leaves the file alone: `-ot 'blk\.14\.ffn_down\.weight=CPU'` (that one multiply stays on the
CPU); about 7 tokens a second, and the first 30 tokens match an all-CPU run.

## Getting letters out of it

Give it a finished letter, a blank line, and only a heading such as `THE REPLY.` It decides who is
answering. See the repository README.
