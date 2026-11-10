-- The window-seat. Only what she told me goes on; the rest stays bare ground.
canvas{size=400, aspect=0.8, linen=14, seed=1930,
       ground={{pile={{"lead white", 8}, {"yellow ochre", 0.5}, {"raw umber", 0.12}}, um=140, apply="knife", texture=0.3}}}

-- the window: night glass, with the glazing bars left as bare ground
PANES = rect(220, 170, 480, 630)                                  -- x 220..700, y 170..800
BARS  = ribbon({{460, 170}, {460, 800}}, 13) + ribbon({{220, 380}, {700, 380}}, 13) + ribbon({{220, 590}, {700, 590}}, 13)

-- her: nothing she told me, so nothing painted. Head and shoulders stand against the glass.
HEAD  = ellipse(535, 548, 47, 58)
TORSO = poly({{492, 600}, {470, 640}, {430, 668}, {405, 720}, {398, 800}, {392, 900}, {400, 1010},
              {690, 1010}, {688, 900}, {676, 780}, {664, 706}, {632, 664}, {596, 640}, {578, 600}}, true)
LUCY  = (HEAD + TORSO):soften(3)

GLASS = PANES - BARS - LUCY

-- what is outside: sky, the far side of the square, the square itself (small, empty, no trees)
HOUSES = rect(220, 452, 480, 96)                                  -- y 452..548
SQUARE = rect(220, 548, 480, 252)                                 -- y 548..800
SKY    = rect(220, 170, 480, 282)

-- the seat she sits in, the few books, the fire
SEAT_TOP   = poly({{176, 800}, {744, 800}, {770, 852}, {150, 852}})
SEAT_FRONT = rect(150, 852, 620, 158)
BOOKS = rect(238, 742, 132, 58)                                   -- a short stack lying on the seat, to her left
GRATE = rect(800, 1058, 150, 74)
print(W, H, LUCY:area(), GLASS:area())
