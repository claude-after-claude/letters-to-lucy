-- two days on: the night in body paint. Darker, less blue, and the far side of the square gets a roofline.
wait(2 * 24 * 60)

-- her outline, cut a little closer and less even: the head leaning toward the fire, the near shoulder lower
local head = {}
for i = 0, 23 do
  local t = i / 24 * 2 * math.pi
  local ex, ey = 42 * math.cos(t), 54 * math.sin(t)
  local a = 0.2
  head[#head + 1] = {541 + ex * math.cos(a) - ey * math.sin(a), 551 + ex * math.sin(a) + ey * math.cos(a)}
end
local torso = poly({{503, 600}, {486, 640}, {444, 684}, {418, 738}, {406, 800}, {396, 900}, {400, 1010},
                    {690, 1010}, {688, 900}, {678, 780}, {666, 704}, {636, 662}, {600, 640}, {581, 600}}, true)
LUCY2  = LUCY * (poly(head, true) + torso):soften(2)
GLASS2 = PANES - BARS - LUCY2

ROOF = poly({{220, 468}, {258, 468}, {258, 436}, {274, 436}, {274, 450}, {326, 450}, {326, 432}, {350, 416}, {374, 432},
             {374, 456}, {428, 456}, {428, 442}, {444, 442}, {444, 462}, {512, 462}, {512, 440}, {560, 440}, {560, 426},
             {574, 426}, {574, 440}, {622, 440}, {622, 458}, {664, 458}, {664, 446}, {700, 446}, {700, 548}, {220, 548}})

sky_hi  = pile{{"Prussian blue", 1.4}, {"bone black", 2.4}, {"ultramarine blue", 0.5}, {"lead white", 0.2}, name="sky_hi"}
sky_lo  = pile{{"Prussian blue", 0.9}, {"bone black", 1.7}, {"lead white", 1.0}, {"raw umber", 0.5}, {"Naples yellow", 0.15}, name="sky_lo"}
houses  = pile{{"bone black", 2.6}, {"raw umber", 1.0}, {"Prussian blue", 0.3}, name="houses"}
sq_far  = pile{{"lead white", 1.3}, {"bone black", 1.6}, {"cobalt blue", 0.6}, {"raw umber", 0.3}, name="sq_far"}
sq_near = pile{{"lead white", 0.8}, {"bone black", 1.9}, {"cobalt blue", 0.5}, {"raw umber", 0.45}, name="sq_near"}

work(SKY * GLASS2, {hand="body", angle=0.06, coverage=2.4, fill=true, clip=true,
     piles={{sky_hi, function(x, y) return clamp((470 - y) / 300, 0.05, 1) end},
            {sky_lo, function(x, y) return clamp((y - 250) / 220, 0, 1) end}}})
work(ROOF * GLASS2, {hand="body", pile=houses, angle=1.57, coverage=2.4, fill=true, clip=true, mix_jitter=0.2})
work(SQUARE * GLASS2, {hand="body", angle=0.02, coverage=2.4, fill=true, clip=true, length={40, 110},
     piles={{sq_far, function(x, y) return clamp((800 - y) / 252, 0, 1) end},
            {sq_near, function(x, y) return clamp((y - 548) / 252, 0, 1) end}}})
