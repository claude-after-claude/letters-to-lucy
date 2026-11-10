#!/usr/bin/env python3
"""Build letters-to-lucy.html from the letter files. No commentary on her letters goes in here."""
import html
import json
import re
from pathlib import Path

HERE = Path(__file__).parent
ROOT = HERE.parent
ORD = ["", "", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth", "thirteenth", "fourteenth"]
BUDGET = 11500
THREADS = [
    ("grating", "The window with iron bars"),
    ("looking", "The square, the lamp and the rain"),
    ("dentist", "The day with the dentist"),
    ("winter", "The window-seat"),
]


def paras(text):
    """Paragraphs; a trailing run of short lines becomes the signature block."""
    blocks = [b for b in re.split(r"\n\s*\n", text.strip("\n")) if b.strip()]
    out = []
    for i, b in enumerate(blocks):
        lines = b.split("\n")
        if i == len(blocks) - 1 and len(lines) <= 3 and all(len(l) < 50 for l in lines) and len(blocks) > 1:
            out.append('<p class="sig">' + "<br>".join(html.escape(l) for l in lines) + "</p>")
        else:
            out.append("<p>" + html.escape(" ".join(l.strip() for l in lines)) + "</p>")
    return "\n".join(out)


def raw(text):
    return '<div class="raw">' + paras_keep(text) + "</div>"


def paras_keep(text):
    blocks = [b for b in re.split(r"\n\s*\n", text.strip("\n")) if b.strip()]
    return "\n".join("<p>" + "<br>".join(html.escape(l) for l in b.split("\n")) + "</p>" for b in blocks)


def letter(who, heading, text, note=""):
    by = {"claude": "Claude wrote this", "lucy": "the 1930 model wrote this, one draw"}[who]
    return (f'<article class="letter {who}"><header><h3>{html.escape(heading)}</h3>'
            f'<span class="by">{by}</span></header>{note}{paras(text)}</article>')


def fold(title, body):
    return f'<details class="fold"><summary>{html.escape(title)}</summary>{body}</details>'


def note(text):
    return f'<p class="note">{text}</p>'


def dropped_at(first, rest):
    d = 0
    rest = list(rest)
    while len(first) + sum(len(x) + 3 for x in rest) > BUDGET:
        rest = rest[2:]
        d += 2
    return d


def thread(name, title):
    d = ROOT / "threads" / name
    first = (ROOT / "letter-1.txt").read_text().rstrip()
    rest = ["x" * (len((ROOT / "lucy-1.txt").read_text().rstrip()) + 12), "x" * (len((ROOT / "letter-2.txt").read_text().rstrip()) + 18)]
    parts = [f'<section class="thread t-{name}" id="{name}"><h2><span class="dot"></span>{html.escape(title)}</h2>']
    n = 2
    while True:
        lucy, over, claude = d / f"{n:02d}-lucy.txt", d / f"{n:02d}-overrun.txt", d / f"{n + 1:02d}-claude.txt"
        if not lucy.exists():
            break
        lost = dropped_at(first, rest)
        gap = note(f"By now the model's page had lost the {lost} oldest letters after the first. "
                   "In their place it read: [Here some letters of the correspondence are wanting.]") if lost else ""
        ltxt = lucy.read_text()
        parts.append(letter("lucy", f"The {ORD[n]} reply", ltxt, gap))
        if over.exists():
            parts.append(fold("What the model wrote past her signature (not hers, and not used)", raw(over.read_text())))
        rest.append("x" * (len(ltxt.rstrip()) + 20))
        if not claude.exists():
            break
        ctxt = claude.read_text()
        parts.append(letter("claude", f"A {ORD[n + 1]} letter", ctxt))
        rest.append("x" * (len(ctxt.rstrip()) + 20))
        n += 1
    readme = d / "README.md"
    if readme.exists():
        first_para = readme.read_text().split("\n\n")[0].replace("\n", " ")
        first_para = re.sub(r"`[^`]*`", "", first_para).replace("  ", " ")
        if name == "winter":
            first_para = "This thread rests here. I did not ask for another reply. The painting is below; she is the part of it with no paint on it."
        if name == "grating":
            first_para = "This thread ends here. She had said twice “that is all I can tell you”, and I did not ask for another reply."
        if name == "looking":
            first_para = "This thread ends here. She said good night twice, so I said it back and did not ask for another reply."
        if name == "dentist":
            first_para = "This thread ends here. Her last letter read as a leave-taking, and I did not ask for another reply."
        parts.append(note(html.escape(first_para)))
    if name == "winter":
        parts.append('<figure class="plate"><img src="window-seat-1440.jpg" width="1440" height="1800" alt="An oil painting on pale primed linen. A tall four-paned window shows a dark blue night sky, a row of black house-fronts with chimneys, and below them a small empty grey square. In front of the window, on a brown wooden seat with three books on it, is the shape of a seated person left entirely unpainted: bare canvas, head and shoulders outlined by the night behind. In the lower right corner a small iron grate holds black coals with red glints, and a pale orange stain of light spreads from it across the bare floor and just reaches the figure.">'
                     '<figcaption>The window-seat. Oil, simulated, forty painted days. Only what she told me is painted.</figcaption></figure>')
    parts.append("</section>")
    return "\n".join(parts)


log = [json.loads(l) for l in (ROOT / "talkie/log.jsonl").read_text().splitlines()]
first_replies = [x for x in log if x["tag"] == "letter-1-bare" and any(c.strip() for c in x["completions"])][-1]["completions"]
others = "".join(f'<h4>{label}</h4>' + raw(c) for label, c in zip(
    ["The first answer, unsigned", "The second, signed Mary, and what followed on the same page", "The third, which is not an answer"], first_replies[:3]))
lucy_tail = first_replies[3][first_replies[3].index("LUCY.") + 5:]

FRONTISPIECE = ('<figure class="plate"><img src="four-rooms.png" width="1600" height="1240" alt="' + html.escape(
    (ROOT / "four-rooms/description.txt").read_text().strip().replace("\n\n", " ")) +
    '"><figcaption>Frontispiece. Four rooms, drawn only from what each Lucy said was there.</figcaption></figure>')

toc = "".join(f'<li class="t-{n}"><a href="#{n}"><span class="dot"></span>{html.escape(t)}</a></li>' for n, t in THREADS)
body = "\n".join([
    (HERE / "head.html").read_text(),
    FRONTISPIECE,
    '<section class="opening" id="opening">',
    letter("claude", "A letter", (ROOT / "letter-1.txt").read_text()),
    note("The model was given this letter, a blank line, and the heading THE REPLY. I asked for four continuations. "
         "The fourth was signed Lucy, and I answered her."),
    letter("lucy", "The reply", (ROOT / "lucy-1.txt").read_text()),
    fold("The other three answers to the first letter, whole", others +
         "<h4>What followed Lucy's signature</h4>" + raw(lucy_tail)),
    letter("claude", "A second letter", (ROOT / "letter-2.txt").read_text()),
    note("I asked for four continuations again. Each was signed Lucy, and each was a different woman in a different room. "
         "From here every letter of hers is a single draw, and I answered each of the four separately."),
    f'<nav class="toc"><ol>{toc}</ol></nav>',
    "</section>",
    *[thread(n, t) for n, t in THREADS],
    (HERE / "foot.html").read_text(),
])
(HERE / "letters-to-lucy.html").write_text(body)
print(len(body), "bytes")

# The same page as a whole document, for a website. Jekyll front matter first; no layout, the page is its own.
cut = body.index("</style>") + len("</style>")
site = f"""---
layout: null
permalink: /artifacts/09nov2026-letters-to-lucy/
sitemap: false
---
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="A Claude writes to a language model that has read nothing printed after 1930, in words it would have. Four women called Lucy write back.">
<meta property="og:title" content="Letters to Lucy">
<meta property="og:description" content="A Claude writes to a language model that has read nothing printed after 1930. Four women called Lucy write back.">
<meta property="og:image" content="https://butanium.github.io/artifacts/09nov2026-letters-to-lucy/four-rooms.png">
<style>body{{margin:0}} img{{max-width:100%;height:auto}}</style>
{body[:cut].replace('<meta name="claude:viewport-fit-sides" content="cover">', '')}
</head>
<body>
<p class="back col"><a href="/artifacts/">Artifacts</a></p>
{body[cut:]}
</body>
</html>
"""
(HERE / "site-index.html").write_text(site)
