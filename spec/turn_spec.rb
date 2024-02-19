require "./spec/spec_helper"

RSpec.describe Turn do
  before(:each) do
    @player_board = Board.new
    @computer_board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
    @turn = Turn.new(@player_board, @computer_board)
  end

  describe "#initialize" do
    it "can initialize" do
      expect(@turn).to be_a(Turn)
    end

    # it "has attributes" do

    # end
  end

  describe "#display_boards" do
    it "can dislay player board" do
      @player_board.place(@cruiser, ["A1", "A2", "A3"])
      player_board = @turn.display_player_board
      expected_output = "==============PLAYER BOARD==============/n" +
                        "  1 2 3 4 /n" +
                        "A S S S . /n" +
                        "B . . . . /n" +
                        "C . . . . /n" +
                        "D . . . . /n"
      expect(player_board).to eq(expected_output)
    end

    it "can display computer board" do
      @computer_board.place(@submarine, ["B1", "B2"])
      computer_board = @turn.display_computer_board
      expected_output = "==============COMPUTER BOARD==============/n" +
                        "  1 2 3 4 /n" +
                        "A . . . . /n" +
                        "B . . . . /n" +
                        "C . . . . /n" +
                        "D . . . . /n"
      expect(computer_board).to eq(expected_output)
    end

    it "can display both boards" do
      @player_board.place(@cruiser, ["A1", "A2", "A3"])
      @computer_board.place(@submarine, ["B1", "B2"])

      expected_output = "==============PLAYER BOARD==============/n" +
                        "  1 2 3 4 /n" +
                        "A S S S . /n" +
                        "B . . . . /n" +
                        "C . . . . /n" +
                        "D . . . . /n" +

                        "==============COMPUTER BOARD==============/n" +
                        "  1 2 3 4 /n" +
                        "A . . . . /n" +
                        "B . . . . /n" +
                        "C . . . . /n" +
                        "D . . . . /n"
      expect(@turn.display_both_boards).to eq(expected_output)
    end
  end



end
