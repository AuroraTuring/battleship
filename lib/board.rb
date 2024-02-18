# To-do: documentation and comments for class Board
class Board
  attr_reader :cells

  def initialize
    @cells = {}
    ("A".."D").each do |row|
      (1..4).each do |column|
        @cells["#{row}#{column}"] = Cell.new("#{row}#{column}")
      end
    end
  end

  def valid_coordinate?(coordinate)
    coordinate.match?(/^[A-D][1-4]$/)
  end
end
