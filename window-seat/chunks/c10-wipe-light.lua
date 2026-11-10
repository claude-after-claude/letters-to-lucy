-- the firelight came out as a blaze, and this fire is burning out. While the glaze is still open,
-- wipe it back with a dry rag, each wipe drawn outward from the grate, so that what stays is a stain.
print(drying(760, 1150), drying(878, 1100))
local cx, cy = 878, 1104
local r = rag{width=58}
local n = 0
for i = 0, 27 do
  local a = i / 28 * 2 * math.pi + 0.11
  local c, s = math.cos(a), math.sin(a)
  local x0, y0 = cx + 92 * c, cy + 62 * s
  local len = 330
  local x1, y1 = clamp(cx + len * c, 8, 992), clamp(cy + len * s, 820, 1242)
  r:wipe({{x0, y0}, {(x0 + x1) / 2, (y0 + y1) / 2}, {x1, y1}}, {pressure={0.7, 0.35}})
  n = n + 1
  if n % 3 == 0 then r:refold() end
  if n % 9 == 0 then r = rag{width=58} end
end
print(r.load)
