require "./spec/spec_helper"

RSpec.describe Board do
  before "each" do
    @board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  describe "#initialize" do
    it "exists" do
      expect(@board).to be_a(Board)
      expect(@cruiser).to be_a(Ship)
    end

    it "initializes Board with cells" do
      @board.cells.each_value do |cell|
        expect(cell).to be_instance_of(Cell)
      end
    end
  end

  describe "#valid_coordinate?" do
    it "knows if a coordinate is on the board" do
      expect(@board.valid_coordinate?("A1")).to be true
      expect(@board.valid_coordinate?("D4")).to be true
    end

    it "knows if a coordinate is not on the board" do
      expect(@board.valid_coordinate?("A5")).to be false
      expect(@board.valid_coordinate?("E1")).to be false
      expect(@board.valid_coordinate?("A22")).to be false
    end
  end

  describe "#valid_placement?" do
  it "ship length" do
    expect(@board.valid_placement?(@cruiser, ["A1", "A2"])).to be false
    expect(@board.valid_placement?(@cruiser, ["A1", "A2", "A3"])).to be true
    expect(@board.valid_placement?(@submarine, ["A2", "A3", "A4"])).to be false
    expect(@board.valid_placement?(@submarine, ["A2", "A3"])).to be true
  end

  it "consecutive_placement" do
    expect(@board.valid_placement?(@cruiser, ["B1", "C1", "D1"])).to be true #vertical
    expect(@board.valid_placement?(@cruiser, ["B1", "B2", "B3"])).to be true #horizontal
    expect(@board.valid_placement?(@cruiser, ["A1", "B2", "C3"])).to be false #diagonal
    expect(@board.valid_placement?(@cruiser, ["A3", "A2", "A1"])).to be false #descending
    expect(@board.valid_placement?(@cruiser, ["A1", "A2", "A4"])).to be false #not consecutive
  end
end


end
