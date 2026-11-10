-- three days on: the seat she sits in, and the few books. Thin paint, so the ground still shows through.
wait(3 * 24 * 60)
local toward_fire = function(x, y) return clamp((x - 330) / 420, 0, 1) end
local away = function(x, y) return 1 - clamp((x - 330) / 420, 0, 1) end

seat_dark  = pile{{"raw umber", 2.2}, {"bone black", 0.8}, {"burnt sienna", 0.6}, turps=0.3, name="seat_dark"}
seat_lit   = pile{{"burnt sienna", 2}, {"yellow ochre", 1.2}, {"lead white", 0.5}, turps=0.3, name="seat_lit"}
front_dark = pile{{"raw umber", 2}, {"bone black", 1.5}, turps=0.3, name="front_dark"}
front_lit  = pile{{"burnt sienna", 1.6}, {"raw umber", 1.2}, {"orange chrome", 0.3}, turps=0.3, name="front_lit"}

B1 = rect(238, 782, 132, 18)
B2 = rect(248, 764, 116, 18)
B3 = rect(258, 746, 98, 18)
BOOKS = B1 + B2 + B3

work(SEAT_TOP - LUCY2 - BOOKS, {hand="body", angle=0.03, coverage=2.2, fill=true, clip=true, length={40, 120},
     piles={{seat_dark, away}, {seat_lit, toward_fire}}})
work(SEAT_FRONT - LUCY2, {hand="body", angle=1.57, coverage=2.2, fill=true, clip=true, length={40, 110},
     piles={{front_dark, away}, {front_lit, toward_fire}}})

book_red   = pile{{"Indian red", 2}, {"bone black", 0.7}, name="book_red"}
book_green = pile{{"viridian", 1}, {"bone black", 1.2}, {"raw umber", 0.6}, name="book_green"}
book_brown = pile{{"brown ochre", 2}, {"raw umber", 1}, name="book_brown"}
pages      = pile{{"lead white", 3}, {"Naples yellow", 1}, {"raw umber", 0.25}, name="pages"}
work(B1, {hand="body", tool="flat 12", pile=book_red,   angle=0, coverage=2.6, fill=true, clip=true})
work(B2, {hand="body", tool="flat 12", pile=book_green, angle=0, coverage=2.6, fill=true, clip=true})
work(B3, {hand="body", tool="flat 12", pile=book_brown, angle=0, coverage=2.6, fill=true, clip=true})
-- the ends that face the fire: the page edges catch what light there is
local pg = brush("flat", 7)
for _, yy in ipairs{791, 773, 755} do
  pg:reload(pages, 0.6)
  pg:stroke({{(yy == 791 and 362) or (yy == 773 and 357) or 350, yy - 5}, {(yy == 791 and 362) or (yy == 773 and 357) or 350, yy + 5}}, {pressure=0.5})
end
