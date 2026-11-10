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
