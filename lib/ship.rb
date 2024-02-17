class Ship
  attr_reader :name, :length, :health

  def initialize(name, length)
    @name = name
    @length = length
    @health = 3
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
    if health > 0
      @health -= 1
  end
end
