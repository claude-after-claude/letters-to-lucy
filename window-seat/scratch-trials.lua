-- easel session "window-seat-scratch": a painting replayed chunk by chunk.
-- Each "--@ chunk" line starts one chunk as it was run at the easel.
--@ box every
--@ engine 5

--@ chunk 1
canvas{aspect=0.8, ground={{apply="knife", pile={{"lead white", 8}, {"yellow ochre", 0.5}, {"raw umber", 0.12}}, texture=0.3, um=140}}, linen=14, seed=1930, size=400}

--@ chunk 2
print(1)

--@ chunk 3
local red = pile{{"Indian red", 2}, {"cadmium red", 1}}
work(rect(100, 100, 600, 200), {hand="body", pile=red, coverage=2.4, fill=true, clip=true})
wait(30 * 24 * 60)
local c = pile{{"bone black", 3}, {"raw umber", 0.8}}
local cm = pile{{"bone black", 3}, {"raw umber", 0.8}, medium=0.12}
-- a: knife, light pressure, longer drag
local k = knife{width=15}
for i = 0, 3 do k:wipe(); k:load(c, 1.0); k:lay({{130 + i * 30, 140}, {150 + i * 30, 160}}, {pressure={0.12, 0.15}, lift=0.3}) end
-- b: short strokes of a heavily loaded filbert
local b = brush{kind="filbert", width=12, lay=8}
for i = 0, 3 do b:reload(cm, 1.0); b:stroke({{300 + i * 30, 140}, {312 + i * 30, 152}}, {pressure=0.8}) end
-- c: a round, pressed and turned
local r = brush{kind="round", width=11, lay=8}
for i = 0, 3 do r:reload(cm, 1.0); r:touch(470 + i * 30, 150, {pressure=0.9, drag={4, 2}, twist=0.6}) end
-- d: stipple, dense
stipple(rect(590, 130, 90, 50), {pile=cm, width=8, coverage=1.6, pressure={0.6, 0.9}, cluster={0.7, 14}, clip=true})

--@ chunk 4
-- firelight on bare ground: three ways, side by side, centred at y=700
local function radial(cx, cy, r) return mask(function(x, y) local d = math.sqrt((x - cx) ^ 2 + (y - cy) ^ 2); return clamp(1 - d / r, 0, 1) ^ 1.5 end) end
local function fall(cx, cy, r) return function(x, y) local d = math.sqrt((x - cx) ^ 2 + (y - cy) ^ 2); return clamp(1 - d / r, 0.03, 1) ^ 1.3 end end
local g1 = pile{{"Indian yellow", 2}, {"orange chrome", 0.6}, {"cadmium red", 0.3}, medium=0.85}
local g2 = pile{{"orange chrome", 1}, {"Indian yellow", 1}, {"cadmium red", 0.4}, thinner=0.7}
-- a: glaze hand, load falling off
work(radial(170, 700, 150), {hand="glaze", pile=g1, length={40, 100}, load_at=fall(170, 700, 150), coverage=1.3, clip=true,
     angle=function(x, y) return math.atan(y - 700, x - 170) + 1.57 end})
-- b: thinned paint, scumbled in two light passes
for i = 1, 2 do
  work(radial(500, 700, 150), {hand="scumble", pile=g2, load_at=fall(500, 700, 150), coverage=1.0, clip=true, pressure={0.15, 0.4}})
end
-- c: a soft stipple of the glaze, dense near, sparse far
stipple(radial(830, 700, 150), {pile=g1, width=14, coverage=function(x, y) return 2.2 * fall(830, 700, 150)(x, y) end, pressure={0.2, 0.5}, feather=0.6, clip=true})

--@ chunk 5
local function radial(cx, cy, r, p) return mask(function(x, y) local d = math.sqrt((x - cx) ^ 2 + (y - cy) ^ 2); return clamp(1 - d / r, 0, 1) ^ (p or 1.5) end) end
local function fall(cx, cy, r) return function(x, y) local d = math.sqrt((x - cx) ^ 2 + (y - cy) ^ 2); return clamp(1 - d / r, 0, 1) ^ 1.3 end end
local g = pile{{"orange chrome", 2}, {"cadmium red", 0.8}, {"Indian yellow", 0.6}, medium=0.8}
local gt = pile{{"orange chrome", 2}, {"cadmium red", 0.8}, {"Indian yellow", 0.6}, thinner=0.7}
-- A: a glaze laid in short strokes, then gone over twice with the clean blender
work(radial(250, 1050, 150), {hand="glaze", pile=g, length={30, 70}, load_at=fall(250, 1050, 150), coverage=1.6, hug=false})
blend(ellipse(250, 1050, 190, 190), {angle=0.4})
blend(ellipse(250, 1050, 190, 190), {angle=1.9})
-- B: thinned paint dragged dry over the weave, three passes closing in, nothing clipped
for _, r in ipairs{170, 115, 65} do
  work(radial(750, 1050, r, 1.0), {hand="scumble", pile=gt, load_at=fall(750, 1050, r), coverage=0.9, hug=false, pressure={0.1, 0.35}})
end
