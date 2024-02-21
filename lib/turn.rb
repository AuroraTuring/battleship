class Turn
  def initialize(player_board, computer_board)
    @player_board = player_board
    @computer_board = computer_board
  end

  # Methods are in alphabetical order

  def check_valid_shot(player_input)
    if valid_coordinate?(player_input)
      if @computer_board.cells[player_input].fired_upon?
        puts "You have already fired on that cell! Choose another one."
        false
      else
        true
      end
    else
      puts "Please enter a valid coordinate between A1 and D4."
      false
    end
  end

  def choose_random_unfired_coordinate
    not_fired_upon_coordinates = []
    @player_board.cells.each do |coordinate, cell|
      not_fired_upon_coordinates << coordinate unless cell.fired_upon?
    end
    not_fired_upon_coordinates.sample
  end

  def display_both_boards
    puts `clear`
    puts display_player_board
    puts ""
    puts display_computer_board
    puts ""
  end

  def display_computer_board
    "==============COMPUTER BOARD==============\n#{@computer_board.render}"
  end

  def display_player_board
    "==============PLAYER BOARD==============\n#{@player_board.render(true)}"
  end

  def prompt_user_shot(computer_won)
    if computer_won
      puts "The computer sank all your ships. You have one more shot to tie the game!"
      puts "Choose a coordinate to fire upon."
    else
      puts "\nIt's your turn! Choose a coordinate to fire upon."
    end
  end

  def show_computer_shot_results(fired_on_coordinate)
    hit_or_miss = @player_board.cells[fired_on_coordinate].hit? ? "hit" : "miss"
    puts ""
    puts "I fired on cell #{fired_on_coordinate}. It's a #{hit_or_miss}!"
    unless hit_or_miss == "hit" && @player_board.cells[fired_on_coordinate].ship.sunk?
      return
    end

    puts ""
    puts "I sunk your #{@player_board.cells[fired_on_coordinate].ship.name}!"
  end

  def show_player_shot_results(fired_on_coordinate)
    hit_or_miss = @computer_board.cells[fired_on_coordinate].hit? ? "hit" : "miss"
    puts ""
    puts "You fired on cell #{fired_on_coordinate}. It's a #{hit_or_miss}!"
    unless hit_or_miss == "hit" && @computer_board.cells[fired_on_coordinate].ship.sunk?
      return
    end

    puts ""
    puts "You sunk my #{@computer_board.cells[fired_on_coordinate].ship.name}!"
  end

  def take_computer_shot
    coordinate_to_fire_upon = choose_random_unfired_coordinate
    @player_board.cells[coordinate_to_fire_upon].fire_upon
    coordinate_to_fire_upon
  end

  def take_player_shot(computer_won)
    prompt_user_shot(computer_won)
    valid_shot, player_input = nil
    until valid_shot
      player_input = gets.chomp.upcase
      valid_shot = check_valid_shot(player_input)
    end
    @computer_board.cells[player_input].fire_upon
    player_input
  end

  def valid_coordinate?(input)
    input.match?(/^[A-Z][1-4]$/)
  end
end
