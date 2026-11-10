-- easel session "window-seat": a painting replayed chunk by chunk.
-- Each "--@ chunk" line starts one chunk as it was run at the easel.
--@ box every
--@ engine 5

--@ chunk 1
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

--@ chunk 2
-- the night outside, laid in lean
lay_sky    = pile{{"Prussian blue", 2}, {"ultramarine blue", 1}, {"bone black", 1.3}, {"lead white", 0.35}, turps=0.45, name="lay_sky"}
lay_houses = pile{{"bone black", 2}, {"raw umber", 1}, {"Prussian blue", 0.5}, turps=0.4, name="lay_houses"}
lay_square = pile{{"lead white", 2}, {"bone black", 1.3}, {"cobalt blue", 0.8}, {"raw umber", 0.3}, turps=0.45, name="lay_square"}
work(SKY * GLASS,    {hand="broad", pile=lay_sky,    angle=0.1, coverage=2.3, fill=true, clip=true})
work(HOUSES * GLASS, {hand="body",  pile=lay_houses, angle=1.57, coverage=2.3, fill=true, clip=true})
work(SQUARE * GLASS, {hand="broad", pile=lay_square, angle=0,   coverage=2.3, fill=true, clip=true})

--@ chunk 3
-- two days on: the night in body paint. Darker, less blue, and the far side of the square gets a roofline.
wait(2 * 24 * 60)

-- her outline, cut a little closer and less even: the head leaning toward the fire, the near shoulder lower
local head = {}
for i = 0, 23 do
  local t = i / 24 * 2 * math.pi
  local ex, ey = 42 * math.cos(t), 54 * math.sin(t)
  local a = 0.2
  head[#head + 1] = {541 + ex * math.cos(a) - ey * math.sin(a), 551 + ex * math.sin(a) + ey * math.cos(a)}
end
local torso = poly({{503, 600}, {486, 640}, {444, 684}, {418, 738}, {406, 800}, {396, 900}, {400, 1010},
                    {690, 1010}, {688, 900}, {678, 780}, {666, 704}, {636, 662}, {600, 640}, {581, 600}}, true)
LUCY2  = LUCY * (poly(head, true) + torso):soften(2)
GLASS2 = PANES - BARS - LUCY2

ROOF = poly({{220, 468}, {258, 468}, {258, 436}, {274, 436}, {274, 450}, {326, 450}, {326, 432}, {350, 416}, {374, 432},
             {374, 456}, {428, 456}, {428, 442}, {444, 442}, {444, 462}, {512, 462}, {512, 440}, {560, 440}, {560, 426},
             {574, 426}, {574, 440}, {622, 440}, {622, 458}, {664, 458}, {664, 446}, {700, 446}, {700, 548}, {220, 548}})

sky_hi  = pile{{"Prussian blue", 1.4}, {"bone black", 2.4}, {"ultramarine blue", 0.5}, {"lead white", 0.2}, name="sky_hi"}
sky_lo  = pile{{"Prussian blue", 0.9}, {"bone black", 1.7}, {"lead white", 1.0}, {"raw umber", 0.5}, {"Naples yellow", 0.15}, name="sky_lo"}
houses  = pile{{"bone black", 2.6}, {"raw umber", 1.0}, {"Prussian blue", 0.3}, name="houses"}
sq_far  = pile{{"lead white", 1.3}, {"bone black", 1.6}, {"cobalt blue", 0.6}, {"raw umber", 0.3}, name="sq_far"}
sq_near = pile{{"lead white", 0.8}, {"bone black", 1.9}, {"cobalt blue", 0.5}, {"raw umber", 0.45}, name="sq_near"}

work(SKY * GLASS2, {hand="body", angle=0.06, coverage=2.4, fill=true, clip=true,
     piles={{sky_hi, function(x, y) return clamp((470 - y) / 300, 0.05, 1) end},
            {sky_lo, function(x, y) return clamp((y - 250) / 220, 0, 1) end}}})
work(ROOF * GLASS2, {hand="body", pile=houses, angle=1.57, coverage=2.4, fill=true, clip=true, mix_jitter=0.2})
work(SQUARE * GLASS2, {hand="body", angle=0.02, coverage=2.4, fill=true, clip=true, length={40, 110},
     piles={{sq_far, function(x, y) return clamp((800 - y) / 252, 0, 1) end},
            {sq_near, function(x, y) return clamp((y - 548) / 252, 0, 1) end}}})

--@ chunk 4
-- three days on: the seat she sits in, and the few books. Thin paint, so the ground still shows through.
wait(3 * 24 * 60)
local toward_fire = function(x, y) return clamp((x - 330) / 420, 0, 1) end
local away = function(x, y) return 1 - clamp((x - 330) / 420, 0, 1) end

seat_dark  = pile{{"raw umber", 2.2}, {"bone black", 0.8}, {"burnt sienna", 0.6}, turps=0.3, name="seat_dark"}
seat_lit   = pile{{"burnt sienna", 2}, {"yellow ochre", 1.2}, {"lead white", 0.5}, turps=0.3, name="seat_lit"}
front_dark = pile{{"raw umber", 2}, {"bone black", 1.5}, turps=0.3, name="front_dark"}
front_lit  = pile{{"burnt sienna", 1.6}, {"raw umber", 1.2}, {"orange chrome", 0.3}, turps=0.3, name="front_lit"}

B1 = rect(238, 782, 132, 18)
B2 = rect(248, 764, 116, 18)
B3 = rect(258, 746, 98, 18)
BOOKS = B1 + B2 + B3

work(SEAT_TOP - LUCY2 - BOOKS, {hand="body", angle=0.03, coverage=2.2, fill=true, clip=true, length={40, 120},
     piles={{seat_dark, away}, {seat_lit, toward_fire}}})
work(SEAT_FRONT - LUCY2, {hand="body", angle=1.57, coverage=2.2, fill=true, clip=true, length={40, 110},
     piles={{front_dark, away}, {front_lit, toward_fire}}})

book_red   = pile{{"Indian red", 2}, {"bone black", 0.7}, name="book_red"}
book_green = pile{{"viridian", 1}, {"bone black", 1.2}, {"raw umber", 0.6}, name="book_green"}
book_brown = pile{{"brown ochre", 2}, {"raw umber", 1}, name="book_brown"}
pages      = pile{{"lead white", 3}, {"Naples yellow", 1}, {"raw umber", 0.25}, name="pages"}
work(B1, {hand="body", tool="flat 12", pile=book_red,   angle=0, coverage=2.6, fill=true, clip=true})
work(B2, {hand="body", tool="flat 12", pile=book_green, angle=0, coverage=2.6, fill=true, clip=true})
work(B3, {hand="body", tool="flat 12", pile=book_brown, angle=0, coverage=2.6, fill=true, clip=true})
-- the ends that face the fire: the page edges catch what light there is
local pg = brush("flat", 7)
for _, yy in ipairs{791, 773, 755} do
  pg:reload(pages, 0.6)
  pg:stroke({{(yy == 791 and 362) or (yy == 773 and 357) or 350, yy - 5}, {(yy == 791 and 362) or (yy == 773 and 357) or 350, yy + 5}}, {pressure=0.5})
end

--@ chunk 5
-- the fire, burning out: first the glow inside the heap, then (once that has set) the dark coals over it
HEAP = poly({{806, 1130}, {812, 1094}, {836, 1070}, {878, 1060}, {920, 1070}, {944, 1096}, {950, 1130}}, true)
local heart = function(x, y) local d = math.sqrt(((x - 878) / 60) ^ 2 + ((y - 1112) / 34) ^ 2); return clamp(1.15 - d, 0, 1) end
local rim   = function(x, y) return 1 - heart(x, y) end
glow_deep = pile{{"Indian red", 2}, {"cadmium red", 1}, {"bone black", 0.4}, name="glow_deep"}
glow_hot  = pile{{"cadmium red", 1.6}, {"orange chrome", 2}, {"cadmium yellow", 0.5}, name="glow_hot"}
work(HEAP, {hand="body", tool="filbert 6", length={8, 22}, angle=function(x, y) return math.atan(y - 1150, x - 878) end,
     coverage=2.6, fill=true, clip=true, piles={{glow_deep, rim}, {glow_hot, heart}}})
wait(4 * 24 * 60)

--@ chunk 6
-- the coals themselves, dark lumps with the glow left showing between them; ash on the tops; the grate
coal = pile{{"bone black", 3}, {"raw umber", 1}, blot=0.2, name="coal"}
ash  = pile{{"lead white", 2}, {"bone black", 1}, {"raw umber", 0.6}, blot=0.2, name="ash"}
spark = pile{{"orange chrome", 2}, {"cadmium yellow", 1.5}, {"lead white", 0.4}, name="spark"}
local lumps = function(x, y)
  local d = math.sqrt(((x - 878) / 60) ^ 2 + ((y - 1112) / 34) ^ 2)
  return 0.25 + 0.75 * clamp(d - 0.15, 0, 1)            -- fewer lumps over the heart, so it shows
end
stipple(HEAP, {pile=coal, tool={kind="filbert", width=11, lay=3}, coverage=lumps, pressure={0.5, 0.9}, cluster={0.7, 22}, drag=4, clip=true})
stipple(HEAP * above(function(x) return 1098 end), {pile=ash, width=5, coverage=0.28, pressure={0.2, 0.5}, cluster={0.6, 14}, clip=true})
local sp = brush("round", 3)
for _, pt in ipairs{{868, 1112}, {884, 1118}, {896, 1108}, {858, 1122}, {878, 1104}} do
  sp:reload(spark, 0.5); sp:touch(pt[1], pt[2], {pressure=0.5})
end
-- the grate: a few iron bars across the front
iron = pile{{"bone black", 3}, {"raw umber", 0.5}, name="iron"}
local ib = brush("flat", 5)
for _, xx in ipairs{812, 845, 878, 911, 944} do
  ib:reload(iron, 0.8); ib:stroke({{xx, 1092}, {xx, 1140}}, {pressure=0.7})
end
ib:reload(iron, 0.9); ib:stroke({{800, 1140}, {956, 1140}}, {pressure=0.8})
ib:reload(iron, 0.9); ib:stroke({{802, 1094}, {954, 1094}}, {pressure=0.5})

--@ chunk 7
-- the heap read as a red loaf: it needs real coals. Opaque black lumps, heaviest round the edge and
-- along the top where they break the outline, with the heart left open.
local cb = brush{kind="filbert", width=13, lay=6, stiffness=0.7}
local lumps = {{822, 1100, 0.3}, {838, 1078, -0.5}, {858, 1064, 0.2}, {884, 1058, -0.2}, {906, 1066, 0.6}, {928, 1082, 0.4},
               {940, 1104, -0.3}, {816, 1120, 0.1}, {846, 1098, 0.9}, {916, 1100, -0.8}, {934, 1122, 0.2}, {898, 1084, 0.3},
               {866, 1084, -0.4}, {828, 1126, 0.5}, {906, 1126, -0.2}, {852, 1128, 0.3}}
for i, l in ipairs(lumps) do
  cb:reload(coal, 0.9)
  cb:touch(l[1], l[2], {pressure=0.75, drag={5 * math.cos(l[3]), 5 * math.sin(l[3])}, twist=l[3], angle=l[3]})
end
-- a little ash on the upper lumps
local ab = brush("round", 4)
for _, l in ipairs{{858, 1060}, {884, 1054}, {906, 1062}, {838, 1074}, {928, 1078}} do
  ab:reload(ash, 0.35); ab:touch(l[1], l[2], {pressure=0.3, drag={3, 0}})
end

--@ chunk 8
--help

--@ chunk 9
-- the lumps went on thin: the red under them was still wet and took them in. Wait until it is dry,
-- then lay the coals with a small knife, in short slabs.
print(drying(878, 1100), drying(840, 1080))
wait(16 * 24 * 60)
print(drying(878, 1100), drying(840, 1080))
coal2 = pile{{"bone black", 3}, {"raw umber", 0.8}, {"Prussian blue", 0.2}, name="coal2"}
local k = knife{width=15}
local slabs = {{818, 1112, 0.4}, {830, 1088, -0.7}, {850, 1070, 0.3}, {876, 1060, -0.1}, {902, 1064, 0.5}, {926, 1080, 0.9},
               {942, 1104, -0.4}, {812, 1128, 0.0}, {848, 1100, 1.0}, {914, 1102, -0.9}, {936, 1126, 0.2}, {894, 1086, 0.2},
               {864, 1086, -0.5}, {832, 1124, 0.6}, {908, 1128, -0.3}, {856, 1128, 0.2}, {886, 1132, 0.0}, {800, 1108, 0.8},
               {954, 1118, -0.6}, {866, 1052, 0.4}, {916, 1060, -0.4}}
for i, s in ipairs(slabs) do
  k:wipe(); k:load(coal2, 0.9)
  local dx, dy = 7 * math.cos(s[3]), 7 * math.sin(s[3])
  k:lay({{s[1] - dx, s[2] - dy}, {s[1] + dx, s[2] + dy}}, {pressure={0.45, 0.6}, lift=0.2})
end

--@ chunk 10
-- from the scratch trials: a dense stipple of black with a little oil in it leaves the red showing in
-- glints between the lumps, and a knife at light pressure lays torn slabs. Both, then the bars again.
coal3 = pile{{"bone black", 3}, {"raw umber", 0.8}, medium=0.12, name="coal3"}
local dens = function(x, y)
  local d = math.sqrt(((x - 878) / 62) ^ 2 + ((y - 1114) / 34) ^ 2)
  return 0.45 + 1.4 * clamp(d - 0.1, 0, 1)
end
stipple(HEAP, {pile=coal3, width=8, coverage=dens, pressure={0.6, 0.9}, cluster={0.7, 14}, clip=true})
local k = knife{width=15}
for _, s in ipairs{{826, 1080, -0.6}, {852, 1063, 0.2}, {880, 1054, -0.1}, {908, 1060, 0.5}, {932, 1078, 0.9}, {948, 1104, -0.5}, {808, 1106, 0.7}} do
  k:wipe(); k:load(coal3, 1.0)
  local dx, dy = 10 * math.cos(s[3]), 10 * math.sin(s[3])
  k:lay({{s[1] - dx, s[2] - dy}, {s[1] + dx, s[2] + dy}}, {pressure={0.12, 0.15}, lift=0.3})
end
local ab = brush("round", 4)
for _, l in ipairs{{852, 1058}, {880, 1049}, {908, 1056}, {828, 1076}, {932, 1074}} do
  ab:reload(ash, 0.4); ab:touch(l[1], l[2], {pressure=0.35, drag={4, 1}})
end
local ib = brush("flat", 5)
for _, xx in ipairs{812, 845, 878, 911, 944} do
  ib:reload(iron, 0.9); ib:stroke({{xx, 1092}, {xx, 1140}}, {pressure=0.75})
end
ib:reload(iron, 0.9); ib:stroke({{800, 1140}, {956, 1140}}, {pressure=0.8})
ib:reload(iron, 0.9); ib:stroke({{802, 1094}, {954, 1094}}, {pressure=0.6})

--@ chunk 11
-- the light of the coals, on whatever is near them: a thin oily orange laid in short strokes outward
-- from the fire, then gone over with the clean blender along the same lines. It falls on the floor,
-- on the end of the seat, and faintly on her. The coals are dry first, so the blender leaves them.
wait(14 * 24 * 60)
print(drying(878, 1100), drying(840, 1076))
local cx, cy = 878, 1104
local function radial(r, p) return mask(function(x, y) local d = math.sqrt((x - cx) ^ 2 + (y - cy) ^ 2); return clamp(1 - d / r, 0, 1) ^ p end) end
local fall = function(x, y) local d = math.sqrt((x - cx) ^ 2 + (y - cy) ^ 2); return clamp(1 - d / 330, 0, 1) ^ 1.3 end
local out = function(x, y) return math.atan(y - cy, x - cx) end
firelight = pile{{"orange chrome", 2}, {"cadmium red", 0.8}, {"Indian yellow", 0.6}, medium=0.8, name="firelight"}
local keep = HEAP:grow(5) + PANES
work(radial(330, 1.5) - keep, {hand="glaze", pile=firelight, length={30, 70}, load_at=fall, coverage=1.6, hug=false, angle=out})
blend(radial(430, 0.7) - keep, {angle=out})
blend(radial(430, 0.7) - keep, {angle=out})

--@ chunk 12
-- the firelight came out as a blaze, and this fire is burning out. While the glaze is still open,
-- wipe it back with a dry rag, each wipe drawn outward from the grate, so that what stays is a stain.
print(drying(760, 1150), drying(878, 1100))
local cx, cy = 878, 1104
local r = rag{width=58}
local n = 0
for i = 0, 27 do
  local a = i / 28 * 2 * math.pi + 0.11
  local c, s = math.cos(a), math.sin(a)
  local x0, y0 = cx + 92 * c, cy + 62 * s
  local len = 330
  local x1, y1 = clamp(cx + len * c, 8, 992), clamp(cy + len * s, 820, 1242)
  r:wipe({{x0, y0}, {(x0 + x1) / 2, (y0 + y1) / 2}, {x1, y1}}, {pressure={0.7, 0.35}})
  n = n + 1
  if n % 3 == 0 then r:refold() end
  if n % 9 == 0 then r = rag{width=58} end
end
print(r.load)

--@ chunk 13
-- still a burst of rays. Go over it again across the first wipes, in arcs round the fire, with fresh rags.
local cx, cy = 878, 1104
for _, rad in ipairs{125, 180, 235, 290} do
  local r = rag{width=58}
  local pts = {}
  for i = 0, 40 do
    local a = i / 40 * 2 * math.pi
    local x, y = cx + rad * math.cos(a), cy + rad * 0.86 * math.sin(a)
    if x > 6 and x < 994 and y > 815 and y < 1244 then pts[#pts + 1] = {x, y}
    elseif #pts > 2 then r:wipe(pts, {pressure=0.5}); r:refold(); pts = {} else pts = {} end
  end
  if #pts > 2 then r:wipe(pts, {pressure=0.5}) end
end
