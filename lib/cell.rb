# To-do: documentation and comments for Cell class
class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
  end

  def empty?
    @ship.nil?
  end

  def place_ship(ship)
    @ship = ship if empty?
  end

  def fired_upon?
    @fired_upon
  end

  def fire_upon
    return if fired_upon?

    @fired_upon = true
    return if empty?

    @ship.hit
  end

  def render(show_ship = false)
    return "S" if !empty? && !fired_upon? && show_ship
    return "M" if empty? && fired_upon?
    return "H" if !empty? && fired_upon? && @ship.health > 0
    return "X" if !empty? && fired_upon? && @ship.health <= 0

    "."
  end
end
