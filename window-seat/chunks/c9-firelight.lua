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
