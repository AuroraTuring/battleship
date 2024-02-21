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
      @computer_board.place(@cruiser, %w[B1 B2 B3])
      @game.check_end_game
      expect(@game.game_in_progress).to eq(true)
      @player_board.cells["A1"].fire_upon
      @player_board.cells["A2"].fire_upon
      @player_board.cells["A3"].fire_upon
      expect(@game.game_in_progress).to eq(false)
    end
  end

  describe "#writing to the console" do
    it "states it has placed ships" do
      @game.computer_has_placed_ships_text
    end
    it "displays the computer's turn" do
      @game.modify_boards(@player_board, @computer_board)
      @player_board.place(@cruiser, %w[A1 A2 A3])
      @computer_board.place(@cruiser, %w[B1 B2 B3])
      turn = Turn.new(@player_board, @computer_board)
      @game.display_computer_turn(turn)
    end
  end

  describe "#handling input" do
    it "converts text to coordinates" do
      coords_array = @game.convert_input_to_coordinates("A1 A2 A3")
      expect(coords_array).to eq(%w[A1 A2 A3])
    end
  end
end
