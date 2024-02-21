class Turn
  def initialize(player_board, computer_board)
    @player_board = player_board
    @computer_board = computer_board
  end

  def display_both_boards
    puts display_player_board + display_computer_board
  end

  def show_computer_shot_results(fired_on_coordinate)
    hit_or_miss = @player_board.cells[fired_on_coordinate].hit? ? "hit" : "miss"
    puts "I fired on cell #{fired_on_coordinate}. It's a #{hit_or_miss}!"
  end

  def show_player_shot_results(fired_on_coordinate)
    hit_or_miss = @computer_board.cells[fired_on_coordinate].hit? ? "hit" : "miss"
    puts "You fired on cell #{fired_on_coordinate}. It's a #{hit_or_miss}!"
  end

  def display_player_board
    "==============PLAYER BOARD==============\n#{@player_board.render(true)}"
  end

  def display_computer_board
    "==============COMPUTER BOARD==============\n#{@computer_board.render}"
  end

  def take_computer_shot
    blank_coordinates = []
    @player_board.cells.each do |coordinate, cell|
      blank_coordinates << coordinate unless cell.fired_upon?
    end
    coordinate_to_fire_upon = blank_coordinates.sample
    @player_board.cells[coordinate_to_fire_upon].fire_upon
    show_computer_shot_results(coordinate_to_fire_upon)
    coordinate_to_fire_upon
  end

  def take_player_shot # rubocop:disable Metrics/MethodLength
    puts "\nIt's your turn! Choose a coordinate to fire upon."
    valid_shot, player_input = nil
    until valid_shot
      player_input = gets.chomp
      if valid_coordinate?(player_input)
        valid_shot = !@computer_board.cells[player_input].fired_upon?
        unless valid_shot
          puts "You have already fired on that cell! Choose another one."
        end
      else
        puts "Please enter a valid coordinate between A1 and D4."
      end
    end
    @computer_board.cells[player_input].fire_upon
    player_input
  end

  def valid_coordinate?(input)
    input.match?(/^[A-Z][1-4]$/)
  end
end
