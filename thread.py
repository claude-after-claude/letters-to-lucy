#!/usr/bin/env python3
"""One correspondence with the 1930 model, kept as files.

    thread.py <name>            # build the prompt from the thread's files, ask for ONE reply, save it
    thread.py <name> --show     # print the prompt that would be sent

A thread is threads/<name>/NN-claude.txt and NN-lucy.txt, after the shared opening (letter-1, lucy-1,
letter-2). Rule: one sample per letter. Whatever comes is her letter; no drawing again for a nicer one.
The reply is cut at her signature; anything the model wrote past it (often my next letter, written for
me) is kept beside it as NN-overrun.txt.
"""
import json
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).parent
ORD = ["", "", "SECOND", "THIRD", "FOURTH", "FIFTH", "SIXTH", "SEVENTH", "EIGHTH", "NINTH", "TENTH", "ELEVENTH", "TWELFTH", "THIRTEENTH", "FOURTEENTH"]


BUDGET = 11500  # characters; the model holds 4096 tokens and the reply needs 600 of them
GAP = "[Here some letters of the correspondence are wanting.]"


def build(name):
    """Letter 1 always stays. When the page is full the oldest letters after it drop out, and a
    bracketed note says so. She only ever has what is on the page."""
    d = HERE / "threads" / name
    first = (HERE / "letter-1.txt").read_text().rstrip()
    rest = ["THE REPLY.\n\n" + (HERE / "lucy-1.txt").read_text().rstrip(),
            "A SECOND LETTER.\n\n" + (HERE / "letter-2.txt").read_text().rstrip()]
    n = 2
    while True:
        lucy, claude = d / f"{n:02d}-lucy.txt", d / f"{n + 1:02d}-claude.txt"
        if not lucy.exists():
            break
        rest.append(f"THE {ORD[n]} REPLY.\n\n" + lucy.read_text().rstrip())
        assert claude.exists(), f"{lucy.name} has no answer yet: write {claude.name}"
        rest.append(f"A {ORD[n + 1]} LETTER.\n\n" + claude.read_text().rstrip())
        n += 1
    dropped = 0
    while len(first) + sum(len(x) + 3 for x in rest) > BUDGET:
        rest = rest[2:]; dropped += 2  # a reply and the letter that answered it go together
    if dropped:
        rest.insert(0, GAP)
        print(f"[{dropped} letters dropped from the page]", file=sys.stderr)
    return "\n\n\n".join([first] + rest) + f"\n\n\nTHE {ORD[n]} REPLY.\n\n", lucy


name = sys.argv[1]
prompt, target = build(name)
if "--show" in sys.argv:
    print(prompt); sys.exit()
tmp = HERE / "threads" / name / ".prompt.txt"
tmp.write_text(prompt)
out = subprocess.run([str(HERE / "talkie/say.py"), "-f", str(tmp), "-n", "1", "--max", "600",
                      "--tag", f"thread-{name}-{target.stem}"], capture_output=True, text=True, check=True).stdout
text = out.split("━━━\n", 1)[1]
cut = text.find("LUCY.")
if cut == -1:
    target.write_text(text.strip("\n") + "\n"); print(f"[no signature; kept whole]\n{text}")
else:
    target.write_text(text[: cut + 5].strip("\n") + "\n")
    rest = text[cut + 5:].strip("\n")
    if rest:
        target.with_name(target.stem.replace("lucy", "overrun") + ".txt").write_text(rest + "\n")
    print(text[: cut + 5].strip("\n")); print("\n[past her signature]\n" + rest if rest else "")
