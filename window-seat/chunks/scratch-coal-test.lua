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
