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
