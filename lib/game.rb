require "./lib/turn"
require "./lib/board"
require "./lib/cell"
require "./lib/ship"
require "json"

class Game # rubocop:disable Metrics/ClassLength
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

  def main_menu # rubocop:disable Metrics/MethodLength
    puts "Welcome to BATTLESHIP!"
    puts "Press 'p' to play or 'q' to quit"
    play_or_quit = ""
    while play_or_quit != "p" && play_or_quit != "q"
      play_or_quit = gets.chomp.downcase
      if play_or_quit == "p"
        break
      elsif play_or_quit == "q"
        return
      else
        puts 'Invalid input. Press "p" to play or "q" to quit'
      end
    end
    start_game
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

  def computer_has_placed_ships_text
    puts `clear`
    puts "I have laid out my ships on the grid. Get ready to place your ships!"
    sleep(3)
  end

  def generate_computer_coordinates(ship_type)
    coordinates = @possible_coordinates[ship_type].sample
    while @computer_board.overlapping(coordinates)
      coordinates = @possible_coordinates[ship_type].sample
    end
    coordinates
  end

  def generate_user_coordinates(ship) # rubocop:disable Metrics/MethodLength
    puts `clear`
    puts "\nPlace your #{ship[0]}. The #{ship[0]} requires #{ship[1]} adjacent " \
         "coordinates.\nSeparate coordinates with a space."
    puts @player_board.render(true)
    valid_user_input = false
    player_input = nil
    until valid_user_input
      player_input = gets.chomp
      valid_user_input = parse_player_coordinates(ship, player_input)
      unless valid_user_input
        puts "\nInvalid coordinates. Write #{ship[1]} coordinates separated by a space.\n"
        puts "#{@player_board.render(true)}\n"
      end
    end
    convert_input_to_coordinates(player_input)
  end

  def parse_player_coordinates(ship, player_input)
    if !player_input.match?(/^([A-D][1-4]\s){#{ship[1] - 1}}[A-D][1-4]$/)
      false
    else
      @player_board.valid_placement?(
        Ship.new(ship[0], ship[1]),
        convert_input_to_coordinates(player_input)
      )
    end
  end

  def convert_input_to_coordinates(input)
    input.split(" ")
  end

  def place(board)
    @ship_list.each do |ship|
      coordinates = if board == @computer_board
                      generate_computer_coordinates(ship[0])
                    else
                      generate_user_coordinates(ship)
                    end
      board.place(Ship.new(ship[0], ship[1]), coordinates)
    end
  end

  def game_loop
    while @game_in_progress
      turn = Turn.new(@player_board, @computer_board)
      computer_coordinates = turn.take_computer_shot
      turn.display_both_boards
      turn.show_computer_shot_results(computer_coordinates)
      player_coordinates = turn.take_player_shot
      turn.show_player_shot_results(player_coordinates)
      check_end_game
    end
    prompt_restart
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

  def list_ships(player_or_computer)
    ships = []
    board = player_or_computer == "player" ? @player_board : @computer_board
    board.cells.each_value do |cell|
      ships << cell.ship if !cell.empty? && !ships.include?(cell.ship)
    end
    ships
  end

  def check_end_game
    @player_wins = list_ships("computer").all?(&:sunk?)
    @computer_wins = list_ships("player").all?(&:sunk?)
    @game_in_progress = false if @player_wins || @computer_wins
  end
end
