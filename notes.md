# A Ship object will represent a single ship on the board. It will be able to keep track of how much health it has, take hits, and report if it is sunk or not. A ship should start off with health equal to it’s length.

pry(main)> require './lib/ship'
#=> true

pry(main)> cruiser = Ship.new("Cruiser", 3)
#=> #<Ship:0x00007feb05112d10...>

pry(main)> cruiser.name
#=> "Cruiser"

pry(main)> cruiser.length
#=> 3

pry(main)> cruiser.health
#=> 3

pry(main)> cruiser.sunk?
#=> false

pry(main)> cruiser.hit

pry(main)> cruiser.health
#=> 2

pry(main)> cruiser.hit

pry(main)> cruiser.health
#=> 1

pry(main)> cruiser.sunk?
#=> false

pry(main)> cruiser.hit

pry(main)> cruiser.sunk?
#=> true
