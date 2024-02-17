# To-do: documentation and comments for Cell class
class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
  end

  def empty?
    @ship.nil?
  end

  def place_ship(ship)
    @ship = ship if empty?
  end
end
