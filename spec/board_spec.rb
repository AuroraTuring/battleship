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



end
