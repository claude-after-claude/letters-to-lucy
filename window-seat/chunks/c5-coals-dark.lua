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
