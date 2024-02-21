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
    @player_board = Board.new
    @computer_board = Board.new
    place_computer_ships
    place_player_ships
    game_loop
  end

  def generate_computer_coordinates(ship_type)
    coordinates = possible_coords[ship_type].sample
    while @computer_board.overlapping(coordinates)
      coordinates = possible_coords[ship_type].sample
    end
  end

  def generate_user_coordinates(ship)
    puts "Place your #{ship[0]}. The #{ship[0]} requires #{ship[1]} adjacent" \
         "coordinates.\nSeparate coordinates with a space, e.g. B2 B3 B4."
    valid_user_input = false
    player_input = nil
    until valid_user_input
      player_input = gets.chomp
      valid_user_input = parse_player_coordinates(ship, player_input)
    end
    convert_input_to_coordinates(player_input)
  end

  def convert_input_to_coordinates(input); end

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

  def place_player_ships
    # puts "I have laid out my ships on the grid.
    # You now need to lay out your two ships.
    # The Cruiser is three units long and the Submarine is two units long.
    #   1 2 3 4
    # A . . . .
    # B . . . .
    # C . . . .
    # D . . . .
    # Enter the squares for the Cruiser (3 spaces):"
    # # display user instructions
    # # recieve input from user for Cruiser
    # # if Cruiser is valid, place on board
    # puts "Enter the squares for the Cruiser (3 spaces):
    # > A1 A2 A3

    #   1 2 3 4
    # A S S S .
    # B . . . .
    # C . . . .
    # D . . . .
    # Enter the squares for the Submarine (2 spaces):"
    # # if Cruiser is invalid, display error, loop for input
    # puts "Enter the squares for the Submarine (2 spaces):
    # > C1 C3
    # Those are invalid coordinates. Please try again:
    # > A1 B1
    # Those are invalid coordinates. Please try again:
    # > C1 D1"
    # # run game_loop to play battleship
  end

  def game_loop
    # recieve shot guess input
    # check for hit or miss (S or .)
    # S becomes H when hit and . becomes M
    # sunk? and ended game or not
    #
  end
end
