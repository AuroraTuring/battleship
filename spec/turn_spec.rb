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

    end

    it "can display computer board" do

    end
  end



end
