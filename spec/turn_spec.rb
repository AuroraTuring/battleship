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

    # Test that it has @turn.computer_board and @turn.player_board
  end

  describe "#display_both_boards" do
    it "can dislay player board" do
      @player_board.place(@cruiser, %w[A1 A2 A3])
      player_board = @turn.display_player_board
      expected_output = "==============PLAYER BOARD==============\n" \
                        "  1 2 3 4 \n" \
                        "A S S S . \n" \
                        "B . . . . \n" \
                        "C . . . . \n" \
                        "D . . . . \n"
      expect(player_board).to eq(expected_output)
    end

    it "can display computer board" do
      @computer_board.place(@submarine, %w[B1 B2])
      computer_board = @turn.display_computer_board
      expected_output = "==============COMPUTER BOARD==============\n" \
                        "  1 2 3 4 \n" \
                        "A . . . . \n" \
                        "B . . . . \n" \
                        "C . . . . \n" \
                        "D . . . . \n"
      expect(computer_board).to eq(expected_output)
    end

    it "can display both boards" do
      @player_board.place(@cruiser, %w[A1 A2 A3])
      @computer_board.place(@submarine, %w[B1 B2])

      expected_output = "==============PLAYER BOARD==============\n" \
                        "  1 2 3 4 \n" \
                        "A S S S . \n" \
                        "B . . . . \n" \
                        "C . . . . \n" \
                        "D . . . . \n" \
                        "==============COMPUTER BOARD==============\n" \
                        "  1 2 3 4 \n" \
                        "A . . . . \n" \
                        "B . . . . \n" \
                        "C . . . . \n" \
                        "D . . . . \n"
      expect(@turn.display_both_boards).to eq(expected_output)
    end
  end

  describe "#get_computer_shot" do
    it "never fires on the same coordinate twice" do
      expected_output = "==============PLAYER BOARD==============\n" \
                        "  1 2 3 4 \n" \
                        "A M M M M \n" \
                        "B M M M M \n" \
                        "C M M M M \n" \
                        "D M M M M \n"

      16.times do
        @turn.take_computer_shot
      end
      expect(@turn.display_player_board).to eq(expected_output)
    end
  end
end
