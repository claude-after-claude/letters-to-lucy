-- the fire, burning out: first the glow inside the heap, then (once that has set) the dark coals over it
HEAP = poly({{806, 1130}, {812, 1094}, {836, 1070}, {878, 1060}, {920, 1070}, {944, 1096}, {950, 1130}}, true)
local heart = function(x, y) local d = math.sqrt(((x - 878) / 60) ^ 2 + ((y - 1112) / 34) ^ 2); return clamp(1.15 - d, 0, 1) end
local rim   = function(x, y) return 1 - heart(x, y) end
glow_deep = pile{{"Indian red", 2}, {"cadmium red", 1}, {"bone black", 0.4}, name="glow_deep"}
glow_hot  = pile{{"cadmium red", 1.6}, {"orange chrome", 2}, {"cadmium yellow", 0.5}, name="glow_hot"}
work(HEAP, {hand="body", tool="filbert 6", length={8, 22}, angle=function(x, y) return math.atan(y - 1150, x - 878) end,
     coverage=2.6, fill=true, clip=true, piles={{glow_deep, rim}, {glow_hot, heart}}})
wait(4 * 24 * 60)
