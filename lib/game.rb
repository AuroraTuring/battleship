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
  end

  def main_menu # rubocop:disable Metrics/MethodLength
    puts 'Press "p" to play or "q" to quit'
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

  def place_computer_ships
    possible_coords = JSON.parse(File.read("./ship_locations.json"))
    cruiser_coords = possible_coords["cruiser"].sample
    submarine_coords = possible_coords["submarine"].sample
    @computer_board.place(Ship.new("Cruiser", 3), cruiser_coords)
    @computer_board.place(Ship.new("Submarine", 2), submarine_coords)
    puts "I have placed down a cruiser and a submarine!"
  end

  def place_player_ships; end

  def game_loop; end
end

Game.new.main_menu
