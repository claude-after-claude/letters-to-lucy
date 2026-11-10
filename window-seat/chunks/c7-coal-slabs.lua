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
