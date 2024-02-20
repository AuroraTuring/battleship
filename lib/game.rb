require "./lib/turn"
require "./lib/board"

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
    puts "game started"
  end
end

Game.new.main_menu
