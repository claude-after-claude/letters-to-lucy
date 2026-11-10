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
