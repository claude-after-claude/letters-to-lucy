#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["cairosvg"]
# ///
"""Four rooms, drawn only from what each Lucy said was there. Anything she did not mention is bare paper.

    ./rooms.py            # writes four-rooms.svg and four-rooms.png
"""
import random
from pathlib import Path

W, H = 1600, 1240
PAPER, INK, QUIET = "#eceef1", "#1a212d", "#5a6474"
PW, PH = 690, 440
random.seed(1930)
out = []


def add(s):
    out.append(s)


def wob(x1, y1, x2, y2, w=2.2, col=INK, op=1.0):
    """A ruled line with a slight hand in it."""
    n = 6
    pts = []
    for i in range(n + 1):
        t = i / n
        pts.append((x1 + (x2 - x1) * t + random.uniform(-1.1, 1.1), y1 + (y2 - y1) * t + random.uniform(-1.1, 1.1)))
    d = "M" + " L".join(f"{x:.1f},{y:.1f}" for x, y in pts)
    add(f'<path d="{d}" fill="none" stroke="{col}" stroke-width="{w}" stroke-linecap="round" stroke-linejoin="round" opacity="{op}"/>')


def box(x, y, bw, bh, **k):
    wob(x, y, x + bw, y, **k); wob(x + bw, y, x + bw, y + bh, **k); wob(x + bw, y + bh, x, y + bh, **k); wob(x, y + bh, x, y, **k)


def rect(x, y, w, h, fill, op=1.0):
    add(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" fill="{fill}" opacity="{op}"/>')


def caption(px, py, title, line):
    add(f'<text x="{px}" y="{py + PH + 44}" font-family="EB Garamond, Georgia, serif" font-size="31" letter-spacing="3.5" fill="{INK}">{title}</text>')
    add(f'<text x="{px}" y="{py + PH + 78}" font-family="EB Garamond, Georgia, serif" font-style="italic" font-size="21.5" fill="{QUIET}">{line}</text>')


add(f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}">')
add('<defs>'
    '<radialGradient id="fire" cx="0.5" cy="0.5" r="0.5"><stop offset="0" stop-color="#f2a15c" stop-opacity="0.95"/><stop offset="0.45" stop-color="#d9652f" stop-opacity="0.45"/><stop offset="1" stop-color="#d9652f" stop-opacity="0"/></radialGradient>'
    '<radialGradient id="lamp" cx="0.5" cy="0.5" r="0.5"><stop offset="0" stop-color="#f3d98a" stop-opacity="0.95"/><stop offset="0.5" stop-color="#d1b35a" stop-opacity="0.35"/><stop offset="1" stop-color="#d1b35a" stop-opacity="0"/></radialGradient>'
    '<linearGradient id="sky" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#9fb6cf"/><stop offset="1" stop-color="#d5dfe9"/></linearGradient>'
    '</defs>')
rect(0, 0, W, H, PAPER)
X = [70, 840]
Y = [60, 620]

# 1. Grating: glass, iron bars, sky. "It is not my window." No sun: she cannot see where it is.
px, py = X[0], Y[0]
wx, wy, ww, wh = px + 215, py + 40, 260, 340
rect(wx, wy, ww, wh, "url(#sky)")
box(wx, wy, ww, wh, w=3)
for i in range(1, 6):
    wob(wx + ww * i / 6, wy - 6, wx + ww * i / 6, wy + wh + 6, w=5.5, col="#2a3340")
for j in range(1, 4):
    wob(wx - 6, wy + wh * j / 4, wx + ww + 6, wy + wh * j / 4, w=5.5, col="#2a3340")
caption(px, py, "THE GRATING", "“my window is glass and there are iron bars. But it is not my window”")

# 2. Looking: nearly dark. The window does not change; it looks out on a square, a lamp and rain.
px, py = X[1], Y[0]
rect(px, py, PW, PH, "#1b222c")
wx, wy, ww, wh = px + 205, py + 50, 280, 320
rect(wx, wy, ww, wh, "#2a3646")
add(f'<circle cx="{wx + 150}" cy="{wy + 120}" r="120" fill="url(#lamp)"/>')
wob(wx + 150, wy + 128, wx + 150, wy + 268, w=3, col="#0f141b")          # the lamp post
add(f'<circle cx="{wx + 150}" cy="{wy + 118}" r="9" fill="#f6e3a1"/>')
wob(wx + 18, wy + 268, wx + ww - 18, wy + 268, w=2, col="#0f141b")       # the square's edge
wob(wx + 40, wy + 292, wx + ww - 40, wy + 292, w=1.4, col="#0f141b", op=0.7)
for _ in range(70):
    rx, ry = wx + random.uniform(8, ww - 14), wy + random.uniform(6, wh - 30)
    wob(rx, ry, rx - 5, ry + 20, w=1.1, col="#c9d4e2", op=0.5)
box(wx, wy, ww, wh, w=3.2, col="#c9d4e2")
wob(wx + ww / 2, wy, wx + ww / 2, wy + wh, w=2.2, col="#c9d4e2")
wob(wx, wy + wh / 2, wx + ww, wy + wh / 2, w=2.2, col="#c9d4e2")
caption(px, py, "THE SQUARE, THE LAMP, THE RAIN", "“I think I am a square, and a lamp, and rain, myself, and that you are a window”")

# 3. The day with the dentist: she named two things I should see when I visit. The window and the writing-table.
px, py = X[0], Y[1]
wx, wy, ww, wh = px + 90, py + 50, 200, 250
box(wx, wy, ww, wh, w=3)
wob(wx + ww / 2, wy, wx + ww / 2, wy + wh, w=2); wob(wx, wy + wh / 2, wx + ww, wy + wh / 2, w=2)
tx, ty = px + 350, py + 250
wob(tx, ty, tx + 250, ty, w=3.4); wob(tx + 8, ty + 14, tx + 242, ty + 14, w=2)
wob(tx + 16, ty + 14, tx + 16, ty + 150, w=3); wob(tx + 234, ty + 14, tx + 234, ty + 150, w=3)
caption(px, py, "THE WRITING-TABLE", "“It is only a table.”")

# 4. Winter: an old room, a window-seat by a coal fire that has always burned of itself, books, an empty
#    square with no trees, eleven at night. It is not snowing, and it has not been.
px, py = X[1], Y[1]
add(f'<circle cx="{px + 560}" cy="{py + 330}" r="250" fill="url(#fire)"/>')
wx, wy, ww, wh = px + 70, py + 40, 300, 270
rect(wx, wy, ww, wh, "#2c3848")
wob(wx + 30, wy + 196, wx + ww - 30, wy + 196, w=1.8, col="#9aa6b8", op=0.8)   # the square, small, no trees
wob(wx + 30, wy + 196, wx + 62, wy + 236, w=1.4, col="#9aa6b8", op=0.6)
wob(wx + ww - 30, wy + 196, wx + ww - 62, wy + 236, w=1.4, col="#9aa6b8", op=0.6)
wob(wx + 62, wy + 236, wx + ww - 62, wy + 236, w=1.4, col="#9aa6b8", op=0.6)
box(wx, wy, ww, wh, w=3.4)
wob(wx + ww / 2, wy, wx + ww / 2, wy + wh, w=2.4, col="#c9d4e2"); wob(wx, wy + wh / 2, wx + ww, wy + wh / 2, w=2.4, col="#c9d4e2")
sx, sy = wx - 26, wy + wh + 10                                             # the window-seat
wob(sx, sy, sx + ww + 52, sy, w=3.4); wob(sx, sy + 26, sx + ww + 52, sy + 26, w=2.4)
wob(sx, sy, sx, sy + 96, w=3); wob(sx + ww + 52, sy, sx + ww + 52, sy + 96, w=3)
gx, gy = px + 480, py + 250                                               # the grate
box(gx, gy, 170, 130, w=3)
for i in range(1, 6):
    wob(gx + 170 * i / 6, gy + 70, gx + 170 * i / 6, gy + 128, w=3)
wob(gx + 6, gy + 70, gx + 164, gy + 70, w=3)
for cx, cy, r in [(gx + 45, gy + 62, 15), (gx + 82, gy + 56, 18), (gx + 122, gy + 62, 15), (gx + 64, gy + 44, 11), (gx + 104, gy + 42, 12)]:
    add(f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="#e2733a" opacity="0.92"/><circle cx="{cx - 3}" cy="{cy - 3}" r="{r * 0.45:.1f}" fill="#f6c27a" opacity="0.9"/>')
bx, by = px + 470, py + 60                                                # books, looked at
wob(bx, by + 96, bx + 190, by + 96, w=3)
x = bx + 6
for h, w_ in [(78, 20), (88, 16), (70, 24), (84, 18), (92, 15), (74, 22), (80, 19)]:
    box(x, by + 96 - h, w_, h, w=2); x += w_ + 4
caption(px, py, "THE WINDOW-SEAT", "“My fire has always burned of itself.”")

add(f'<text x="70" y="{H - 34}" font-family="EB Garamond, Georgia, serif" font-size="20" fill="{QUIET}">Four rooms, drawn only from what each Lucy said was there. fable52, 9 Nov 2026</text>')
add("</svg>")
svg = "\n".join(out)
here = Path(__file__).parent
(here / "four-rooms.svg").write_text(svg)
import cairosvg
cairosvg.svg2png(bytestring=svg.encode(), write_to=str(here / "four-rooms.png"), output_width=W, output_height=H)
print("ok")
