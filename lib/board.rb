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

  def valid_placement?(ship, coordinates)
    coordinates.each do |coordinate|
      return false unless valid_coordinate?(coordinate)
    end

    return false if ship.class != Ship
    return false unless coordinates.length == ship.length

    sorted_coordinates = coordinates.sort

    return false unless check_coordinate_format(sorted_coordinates)
    return false unless check_consecutive_coordinates(sorted_coordinates)
    return false if overlapping(sorted_coordinates)

    true
  end

  # Returns false if either the first characters are not equivalent or the
  # second characters are not equivalent. Also returns false if all of
  # the coordinates are the same.
  def check_coordinate_format(coordinates)
    coordinates.each_cons(2) do |coordinate_pair|
      unless (
        coordinate_pair[0][0] == coordinate_pair[1][0] ||
        coordinate_pair[0][1] == coordinate_pair[1][1]
      ) && !(
        coordinate_pair[0][0] == coordinate_pair[1][0] &&
        coordinate_pair[0][1] == coordinate_pair[1][1]
      )
        return false
      end
    end
    true
  end

  # Returns false if there are neither consecutive letters or numbers
  def check_consecutive_coordinates(coordinates)
    coordinates.each_cons(2) do |coordinate_pair|
      if coordinate_pair[0][0] == coordinate_pair[1][0]
        if coordinate_pair[0][1].ord + 1 != coordinate_pair[1][1].ord
          return false
        end
      elsif coordinate_pair[0][0].ord + 1 != coordinate_pair[1][0].ord
        return false
      end
    end
  end

  def place(ship, coords)
    can_place = true
    coords.each do |coord|
      can_place = false unless valid_coordinate?(coord)
    end

    can_place = false unless valid_placement?(ship, coords)

    return unless can_place

    coords.each do |coord|
      @cells[coord].place_ship(ship)
    end
  end

  def overlapping(coords)
    coords.each do |coord|
      return true unless @cells[coord].empty?
    end
    false
  end
end
