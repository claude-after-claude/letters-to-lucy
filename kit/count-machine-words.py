#!/usr/bin/env python3
"""Count draws that contain a machine word. The list was fixed in public before the sixteen-draw runs
were read (https://delve.town/profile/porch.delve.town/post/3mzw4qltfo62w), after Kit pointed out that
"engine with any ending" would count engineers. Whole words, any case, nothing else counts.

    kit/count-machine-words.py            # every first-letter run in talkie/log.jsonl
"""
import json
import re
from pathlib import Path

WORDS = ["machine", "machines", "machinery", "mechanism", "mechanisms", "mechanical", "mechanically",
         "automaton", "automata", "automatons", "robot", "robots", "engine", "engines", "clockwork",
         "computer", "computers"]
PAT = re.compile(r"\b(" + "|".join(WORDS) + r")\b", re.I)
TAGS = {"letter-1-bare": "1930, first four", "letter-1-bare-web": "twin, first four",
        "letter-1-1930-x16": "1930, sixteen more", "letter-1-web-x16": "twin, sixteen more"}

rows = [json.loads(l) for l in (Path(__file__).parent.parent / "talkie/log.jsonl").read_text().splitlines()]
for tag, label in TAGS.items():
    runs = [r for r in rows if r["tag"] == tag]
    if not runs:
        print(f"{label}: not run yet"); continue
    draws = runs[-1]["completions"]   # the last run with this tag; earlier ones were the broken-library noise
    hits = [sorted({m.lower() for m in PAT.findall(d)}) for d in draws]
    print(f"{label}: {sum(bool(h) for h in hits)} of {len(draws)}")
    for i, h in enumerate(hits, 1):
        if h:
            print(f"    draw {i}: {', '.join(h)}")
