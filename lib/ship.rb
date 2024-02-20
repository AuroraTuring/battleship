# To-do: add comments/documentation for class Ship
class Ship
  attr_reader :name, :length, :health

  def initialize(name, length)
    @name = name
    @length = length
    @health = length
  end

  def sunk?
    @health <= 0
    # if @health == 0
    #   @sunk = true
    # else
    #   @sunk
    # end
  end

  def hit
    @health -= 1 if health > 0
  end
end
