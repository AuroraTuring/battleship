class Turn
  attr_reader :player_board, :computer_board

  def initialize(player_board, computer_board)
    @player_board = player_board
    @computer_board = computer_board
  end

  # Methods are in alphabetical order

  # 1. Fire on a coordinate
  # 2. Try to fire again on that coordinate
  # 3. Check that it returns false
  # 4. Try to fire on a different coordinate
  # 5. Check that it returns true
  # 6. Try to fire on an invalid coordinate (A8)
  # 7. Check that it returns false
  def check_valid_shot(player_input)
    player_input = player_input.upcase
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

  # Needs unit test
  # 1. Take a shot on A1
  # 2. Run 100 choose_random_unfired_coordinate
  # 3. Return value never equals A1
  # Extra credit:
  # 4. Create empty array, append coordinate to array each iteration
  # 5. Check that they are not all the same coordinate
  def choose_random_unfired_coordinate
    not_fired_upon_coordinates = []
    @player_board.cells.each do |coordinate, cell|
      not_fired_upon_coordinates << coordinate unless cell.fired_upon?
    end
    not_fired_upon_coordinates.sample
  end

  # Has test
  def display_both_boards
    puts `clear`
    puts display_player_board
    puts ""
    puts display_computer_board
    puts ""
  end

  # Has test
  def display_computer_board
    "==============COMPUTER BOARD==============\n#{@computer_board.render}"
  end

  # Has test
  def display_player_board
    "==============PLAYER BOARD==============\n#{@player_board.render(true)}"
  end

  # Requires 2 tests - one for computer_won == true
  # and one for computer_won == false
  # Check puts statements for each case
  def prompt_user_shot(computer_won = false)
    if computer_won
      puts "The computer sank all your ships. You have one more shot to tie the game!"
      puts "Choose a coordinate to fire upon."
    else
      puts "\nIt's your turn! Choose a coordinate to fire upon."
    end
  end

  # Needs 3 tests - one for miss, one for hit, one for sink
  # Check puts statements for each case
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

  # Needs 3 tests - one for miss, one for hit, one for sink
  # Check puts statements for each case
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

  # Test:
  # (requires mock/stub)
  # let(:choose_random_unfired_coordinate).respond_with("A1")
  # - Check that the return value is "A1"
  # https://backend.turing.edu/module1/lessons/mocks_stubs
  def take_computer_shot
    coordinate_to_fire_upon = choose_random_unfired_coordinate
    @player_board.cells[coordinate_to_fire_upon].fire_upon
    coordinate_to_fire_upon
  end

  # Test:
  # Low-priority test due to user input
  def take_player_shot(computer_won)
    prompt_user_shot(computer_won)
    valid_shot, player_input = nil
    until valid_shot
      player_input = gets.chomp.upcase # put in its own method and mock/stub
      valid_shot = check_valid_shot(player_input)
    end
    @computer_board.cells[player_input].fire_upon
    player_input
  end

  # Test:
  # check that turn.valid_coordinate?(text) is true for coordinates like A1, B3,
  # etc, and is not valid for coordinates like A0, 33, AA1, A1 with a space, etc
  def valid_coordinate?(input)
    input = input.upcase
    input.match?(/^[A-Z][1-4]$/)
  end
end
