-- the night outside, laid in lean
lay_sky    = pile{{"Prussian blue", 2}, {"ultramarine blue", 1}, {"bone black", 1.3}, {"lead white", 0.35}, turps=0.45, name="lay_sky"}
lay_houses = pile{{"bone black", 2}, {"raw umber", 1}, {"Prussian blue", 0.5}, turps=0.4, name="lay_houses"}
lay_square = pile{{"lead white", 2}, {"bone black", 1.3}, {"cobalt blue", 0.8}, {"raw umber", 0.3}, turps=0.45, name="lay_square"}
work(SKY * GLASS,    {hand="broad", pile=lay_sky,    angle=0.1, coverage=2.3, fill=true, clip=true})
work(HOUSES * GLASS, {hand="body",  pile=lay_houses, angle=1.57, coverage=2.3, fill=true, clip=true})
work(SQUARE * GLASS, {hand="broad", pile=lay_square, angle=0,   coverage=2.3, fill=true, clip=true})
