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
    it "can initialize with attributes" do
      expect(@turn).to be_a(Turn)
      expect(@turn.computer_board).to eq(@computer_board)
      expect(@turn.player_board).to eq(@player_board)
    end
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

  describe "#check_valid_shot" do
    it "cannot fire on coordinates that have already been fired upon" do
      @turn.take_computer_shot
      expect(@turn.check_valid_shot("A1")).to be true
      allow(@turn).to receive(:get_player_input).and_return("A1")

      @turn.take_player_shot(false)
      expect(@turn.check_valid_shot("A1")).to be false
      expected = "You have already fired on that cell! Choose another one.\n"
      expect { @turn.check_valid_shot("A1") }.to output(expected).to_stdout
    end

    it "when invalid coordinates are entered, it puts a statement to return false" do
      @turn.take_computer_shot
      expect(@turn.check_valid_shot("A8")).to be false
      expected = "Please enter a valid coordinate between A1 and D4.\n"
      expect { @turn.check_valid_shot("A8") }.to output(expected).to_stdout
    end
  end

  describe "#choose_random_unfired_coordinate" do
    it "will choose a coordinate that has not been fired upon" do
      # letter a-d
      # and number 1-4
      cells_fired_upon = []
      @player_board.cells["A1"].fire_upon
      100.times do
        unfired_coordinate = @turn.choose_random_unfired_coordinate
        cells_fired_upon << unfired_coordinate
        expect(unfired_coordinate).to_not eq("A1")
      end
      expect(cells_fired_upon.uniq.size > 1).to be true
    end
  end
end
