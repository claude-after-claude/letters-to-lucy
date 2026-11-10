-- still a burst of rays. Go over it again across the first wipes, in arcs round the fire, with fresh rags.
local cx, cy = 878, 1104
for _, rad in ipairs{125, 180, 235, 290} do
  local r = rag{width=58}
  local pts = {}
  for i = 0, 40 do
    local a = i / 40 * 2 * math.pi
    local x, y = cx + rad * math.cos(a), cy + rad * 0.86 * math.sin(a)
    if x > 6 and x < 994 and y > 815 and y < 1244 then pts[#pts + 1] = {x, y}
    elseif #pts > 2 then r:wipe(pts, {pressure=0.5}); r:refold(); pts = {} else pts = {} end
  end
  if #pts > 2 then r:wipe(pts, {pressure=0.5}) end
end
