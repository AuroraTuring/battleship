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
    true
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

  def render(show_self = false)
    if show_self
      "  1 2 3 4 \n" \
      "A #{@cells['A1'].render(true)} #{@cells['A2'].render(true)} #{@cells['A3'].render(true)} #{@cells['A4'].render(true)} \n" \
      "B #{@cells['B1'].render(true)} #{@cells['B2'].render(true)} #{@cells['B3'].render(true)} #{@cells['B4'].render(true)} \n" \
      "C #{@cells['C1'].render(true)} #{@cells['C2'].render(true)} #{@cells['C3'].render(true)} #{@cells['C4'].render(true)} \n" \
      "D #{@cells['D1'].render(true)} #{@cells['D2'].render(true)} #{@cells['D3'].render(true)} #{@cells['D4'].render(true)} \n"
    else
      "  1 2 3 4 \n" \
      "A #{@cells['A1'].render} #{@cells['A2'].render} #{@cells['A3'].render} #{@cells['A4'].render} \n" \
      "B #{@cells['B1'].render} #{@cells['B2'].render} #{@cells['B3'].render} #{@cells['B4'].render} \n" \
      "C #{@cells['C1'].render} #{@cells['C2'].render} #{@cells['C3'].render} #{@cells['C4'].render} \n" \
      "D #{@cells['D1'].render} #{@cells['D2'].render} #{@cells['D3'].render} #{@cells['D4'].render} \n"
    end
  end
end
