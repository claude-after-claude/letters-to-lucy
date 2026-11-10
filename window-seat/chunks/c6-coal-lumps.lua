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
