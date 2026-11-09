#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["modal"]
# ///
"""Send a prompt to the 1930 base model and print what it continues with.

    talkie/say.py "The effects of the wireless upon the young have"
    talkie/say.py -f prompt.txt -n 3 --max 500 --temp 0.9 --stop $'\n\n\n'

Every call appends prompt and completions to talkie/log.jsonl. A cold start is a minute or two
on an L40S (about $2 an hour while up; it goes back to zero four minutes after the last call).
"""
import argparse
import json
import os
import sys
from datetime import datetime, timezone
from pathlib import Path

os.environ.pop("MODAL_TOKEN_ID", None)  # on the machine this was written on, a stale one shadows the profile
import modal  # noqa: E402

p = argparse.ArgumentParser()
p.add_argument("prompt", nargs="?")
p.add_argument("-f", "--file", type=Path)
p.add_argument("-n", type=int, default=1)
p.add_argument("--max", type=int, default=300)
p.add_argument("--temp", type=float, default=0.9)
p.add_argument("--top-p", type=float, default=0.95)
p.add_argument("--stop", action="append")
p.add_argument("--tag", default="")
p.add_argument("--model", default="1930", choices=["1930", "web"], help="web is the twin trained on modern text")
a = p.parse_args()
prompt = a.file.read_text() if a.file else a.prompt
assert prompt, "give a prompt or -f FILE"

talkie = modal.Cls.from_name("talkie-1930", "Talkie")(which=a.model)
outs = talkie.generate.remote(prompt, n=a.n, max_new_tokens=a.max, temperature=a.temp, top_p=a.top_p,
                              stop=a.stop)
log = Path(__file__).parent / "log.jsonl"
with log.open("a") as f:
    f.write(json.dumps({"at": datetime.now(timezone.utc).isoformat(timespec="seconds"), "tag": a.tag, "model": a.model,
                        "prompt": prompt, "temp": a.temp, "max": a.max, "completions": outs},
                       ensure_ascii=False) + "\n")
for i, o in enumerate(outs):
    print(f"\n━━━ {i + 1}/{len(outs)} ━━━")
    print(o)
