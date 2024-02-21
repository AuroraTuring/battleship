require "./spec/spec_helper"

RSpec.describe Game do
  before(:each) do
    @game = Game.new
    @player_board = Board.new
    @computer_board = Board.new
    @cruiser = Ship.new("cruiser", 3)
    @submarine = Ship.new("submarine", 2)
  end

  describe "#initialization" do
    it "exists" do
      expect(@game).to be_an_instance_of(Game)
    end
    it "initializes attributes" do
      expect(@game.player_board).to eq(nil)
      expect(@game.computer_board).to eq(nil)
      expect(@game.game_in_progress).to eq(false)
    end
  end

  describe "#place computer ships" do
    it "can place random ship locations" do
      @game.modify_boards(@player_board, @computer_board)
      @computer_board.place(@cruiser, %w[A1 A2 A3])
      100.times do
        random_coords = @game.generate_computer_coordinates("submarine")
        expect(random_coords.include?("A1")).to eq(false)
        expect(random_coords.include?("A2")).to eq(false)
        expect(random_coords.include?("A3")).to eq(false)
      end
    end
  end

  describe "#end game" do
    it "recognizes the end of the game" do
      @game.modify_boards(@player_board, @computer_board)
      @game.modify_game_in_progress(true)
      @player_board.place(@cruiser, %w[A1 A2 A3])
      comp_cruiser = Ship.new("cruiser", 3)
      @computer_board.place(comp_cruiser, %w[B1 B2 B3])
      @game.check_end_game
      expect(@game.game_in_progress).to eq(true)
      @player_board.cells["A1"].fire_upon
      @player_board.cells["A2"].fire_upon
      @player_board.cells["A3"].fire_upon
      expect(@game.game_in_progress).to eq(false)
    end
  end

  describe "#writing to the console" do
    xit "states it has placed ships" do
      @game.computer_has_placed_ships_text
    end
    xit "displays the computer's turn" do
      @game.modify_boards(@player_board, @computer_board)
      @player_board.place(@cruiser, %w[A1 A2 A3])
      comp_cruiser = Ship.new("cruiser", 3)
      @computer_board.place(comp_cruiser, %w[B1 B2 B3])
      turn = Turn.new(@player_board, @computer_board)
      @game.display_computer_turn(turn)
    end
    xit "prompts ship placement" do
      @game.modify_boards(@player_board, @computer_board)
      @player_board.place(@cruiser, %w[A1 A2 A3])
      @game.prompt_ship_placement(["submarine", 2])
    end
  end

  describe "#handling input" do
    it "converts text to coordinates" do
      coords_array = @game.convert_input_to_coordinates("A1 A2 A3")
      expect(coords_array).to eq(%w[A1 A2 A3])
    end
  end

  describe "#listing ships" do
    it "can list ships on the board" do
      @game.modify_boards(@player_board, @computer_board)
      @player_board.place(@cruiser, %w[A1 A2 A3])
      @player_board.place(@submarine, %w[B1 B2])
      comp_cruiser = Ship.new("cruiser", 3)
      comp_submarine = Ship.new("submarine")
      @computer_board.place(comp_cruiser, %w[A1 A2 A3])
      @computer_board.place(comp_submarine, %w[B1 B2])
      player_ships = @game.list_ships("player")
      computer_ships = @game.list_ships("computer")
      expect(player_ships).to eq([@cruiser, @submarine])
      expect(computer_ships).to eq([player_ships, computer_ships])
    end
  end

  describe "#spec helper methods" do
    it "can modify game boards" do
      @game.modify_boards(@player_board, @computer_board)
      expect(@game.player_board).to eq(@player_board)
      expect(@game.computer_board).to eq(@computer_board)
    end
    it "can modify game in progress" do
      @game.modify_game_in_progress(true)
      expect(@game.game_in_progress).to eq(true)
      @game.modify_game_in_progress(false)
      expect(@game.game_in_progress).to eq(false)
    end
  end

  describe "#validation methods" do
    it "can identify valid coordinate format" do
      is_valid = @game.valid_coordinate_format?(["submarine"], "A1 A2")
      expect(is_valid).to eq(true)
      is_valid = @game.valid_coordinate_format?(["submarine"], "A1 A2 A3")
      expect(is_valid).to eq(false)
      is_valid = @game.valid_coordinate_format?(["submarine"], "A0 A1")
      expect(is_valid).to eq(false)
      is_valid = @game.valid_coordinate_format?(["submarine"], "A1, A2")
      expect(is_valid).to eq(false)
    end
    it "can identify valid placement" do
      @game.modify_boards(@player_board, @computer_board)
      @player_board.place(@cruiser, %w[A1 A2 A3])
      is_valid = @game.valid_placement?(["submarine", 2], "B1 B2")
      expect(is_valid).to eq(true)
      is_valid = @game.valid_placement?(["submarine", 2], "A1 B1")
      expect(is_valid).to eq(false)
      is_valid = @game.valid_placement?(["submarine", 2], "B1 B2 B3")
      expect(is_valid).to eq(false)
      is_valid = @game.valid_placement?(["submarine", 2], "B0 B1")
      expect(is_valid).to eq(false)
    end
    it "can identify valid play or quit" do
      pass1 = @game.valid_play_or_quit("p")
      pass2 = @game.valid_play_or_quit("P")
      pass3 = @game.valid_play_or_quit("q")
      pass4 = @game.valid_play_or_quit("Q")
      fail1 = @game.valid_play_or_quit("")
      fail2 = @game.valid_play_or_quit("asdfjk")
      expect(pass1).to eq(true)
      expect(pass2).to eq(true)
      expect(pass3).to eq(true)
      expect(pass4).to eq(true)
      expect(fail1).to eq(false)
      expect(fail2).to eq(false)
    end
    it "can identify valid yes or no" do
      pass1 = @game.valid_play_or_quit("y")
      pass2 = @game.valid_play_or_quit("Y")
      pass3 = @game.valid_play_or_quit("n")
      pass4 = @game.valid_play_or_quit("N")
      fail1 = @game.valid_play_or_quit("")
      fail2 = @game.valid_play_or_quit("asdfjk")
      expect(pass1).to eq(true)
      expect(pass2).to eq(true)
      expect(pass3).to eq(true)
      expect(pass4).to eq(true)
      expect(fail1).to eq(false)
      expect(fail2).to eq(false)
    end
  end
end
