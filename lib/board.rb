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

  def valid_placement?(ship, coordinates) # rubocop:disable Metrics/MethodLength
    coordinates.each do |coordinate|
      return false unless valid_coordinate?(coordinate)
    end

    return false if ship.class != Ship

    return false unless coordinates.length == ship.length

    sorted_coordinates = coordinates.sort

    # Returns false if either the first characters are not equivalent or the
    # second characters are not equivalent. Also returns false if all of
    # the coordinates are the same.
    sorted_coordinates.each_cons(2) do |coordinate_pair|
      unless (
          coordinate_pair[0][0] == coordinate_pair[1][0] ||
          coordinate_pair[0][1] == coordinate_pair[1][1]
        ) && !(
          coordinate_pair[0][0] == coordinate_pair[1][0] &&
          coordinate_pair[0][1] == coordinate_pair[1][1]
        )
        return false
      end

      # Returns false if there are neither consecutive letters or numbers
      vertical_or_horizontal = if coordinate_pair[0][0] == coordinate_pair[1][0]
                                 "horizontal"
                               else
                                 "vertical"
                               end

      if vertical_or_horizontal == "horizontal"
        if coordinate_pair[0][1].ord + 1 != coordinate_pair[1][1].ord
          return false
        end
      elsif coordinate_pair[0][0].ord + 1 != coordinate_pair[1][0].ord
        return false
      end
    end

    true
  end
end
