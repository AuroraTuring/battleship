require "./lib/turn"
require "./lib/board"
require "./lib/cell"
require "./lib/ship"
require "json"

class Game
  def initialize
    @player_board = nil
    @computer_board = nil
    @game_in_progress = false
    @ship_list = [["cruiser", 3], ["submarine", 2]]
    @possible_coordinates = JSON.parse(File.read("./ship_locations.json"))
    @player_wins = false
    @computer_wins = false
    main_menu
  end

  # Methods are listed in alphabetical order

  def check_end_game
    @player_wins = list_ships("computer").all?(&:sunk?)
    @computer_wins = list_ships("player").all?(&:sunk?)
    @game_in_progress = false if @player_wins || @computer_wins
  end

  def computer_has_placed_ships_text
    puts `clear`
    puts "I have laid out my ships on the grid. Get ready to place your ships!"
    sleep(3)
  end

  def convert_input_to_coordinates(input)
    input.split(" ")
  end

  def display_computer_turn(turn)
    turn.display_both_boards
    puts "Hmmm... let me think..."
    sleep(2)
    computer_coordinates = turn.take_computer_shot
    turn.show_computer_shot_results(computer_coordinates)
    sleep(3)
    turn.display_both_boards
    sleep(0.5)
  end

  def display_player_turn(turn, computer_won)
    player_coordinates = turn.take_player_shot(computer_won)
    turn.display_both_boards
    turn.show_player_shot_results(player_coordinates)
    sleep(2)
  end

  def game_loop
    while @game_in_progress
      turn = Turn.new(@player_board, @computer_board)
      display_computer_turn(turn)
      check_end_game
      display_player_turn(turn, @computer_wins)
      check_end_game
    end
    prompt_restart
  end

  def generate_computer_coordinates(ship_name)
    coordinates = @possible_coordinates[ship_name].sample
    while @computer_board.overlapping(coordinates)
      coordinates = @possible_coordinates[ship_name].sample
    end
    coordinates
  end

  def generate_user_coordinates(ship_info)
    prompt_ship_placement(ship_info)
    valid_user_input, player_input = nil
    until valid_user_input
      player_input = gets.chomp.upcase
      valid_user_input = valid_placement?(ship_info, player_input)
      next if valid_user_input

      puts `clear`
      puts "\nInvalid coordinates. Write #{ship_info[1]} coordinates separated by a space.\n"
      puts "\n#{@player_board.render(true)}\n"
    end
    convert_input_to_coordinates(player_input)
  end

  def list_ships(player_or_computer)
    ships = []
    board = player_or_computer == "player" ? @player_board : @computer_board
    board.cells.each_value do |cell|
      ships << cell.ship if !cell.empty? && !ships.include?(cell.ship)
    end
    ships
  end

  def main_menu
    puts "Welcome to BATTLESHIP!\nPress 'p' to play or 'q' to quit"
    play_or_quit, valid_input = nil
    until valid_input
      play_or_quit = gets.chomp.downcase
      valid_input = play_or_quit.match?(/^(p|q)$/)
      puts "Invalid input. Press 'p' to play or 'q' to quit." unless valid_input
    end
    start_game if play_or_quit == "p"
  end

  def parse_restart_input
    restart_input = nil
    valid_input = false
    until valid_input
      restart_input = gets.chomp.downcase
      valid_input = restart_input.match?(/^(y|n)$/)
      puts "Invalid input. Please enter 'y' or 'n'." unless valid_input
    end
    restart_input == "y" ? start_game : return
  end

  def place(board)
    @ship_list.each do |ship_info|
      coordinates = if board == @computer_board
                      generate_computer_coordinates(ship_info[0])
                    else
                      generate_user_coordinates(ship_info)
                    end
      board.place(Ship.new(ship_info[0], ship_info[1]), coordinates)
    end
  end

  def prompt_restart
    if @player_wins && @computer_wins
      puts "It's a tie! Would you like to play again? (y/n)"
    elsif @player_wins
      puts "You won! Would you like to play again? (y/n)"
    elsif @computer_wins
      puts "The computer won! Would you like to play again? (y/n)"
    end
    parse_restart_input
  end

  def prompt_ship_placement(ship_info)
    puts `clear`
    puts "\nPlace your #{ship_info[0]}. The #{ship_info[0]} requires " \
         "#{ship_info[1]} adjacent coordinates.\nSeparate coordinates " \
         "with a space."
    puts ""
    puts "Your board:"
    puts ""
    puts @player_board.render(true)
    puts ""
  end

  def start_game
    @game_in_progress = true
    @player_board = Board.new
    @computer_board = Board.new
    place(@computer_board)
    computer_has_placed_ships_text
    place(@player_board)
    game_loop
  end

  def valid_placement?(ship_info, player_input)
    # This first conditional checks if the user typed n coordinates separated by
    # spaces, where n is the ship's length. If true, it runs the "else" section
    if !player_input.match?(/^([A-D][1-4]\s){#{ship_info[1] - 1}}[A-D][1-4]$/)
      false
    else
      # It then checks whether the coordinates are a valid location using the
      # Board.valid_placement? method.
      @player_board.valid_placement?(
        Ship.new(ship_info[0], ship_info[1]),
        convert_input_to_coordinates(player_input)
      )
    end
  end
end
