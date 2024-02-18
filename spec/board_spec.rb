require "./spec/spec_helper"

RSpec.describe Board do # rubocop:disable Metrics/BlockLength
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
    it "knows ship length" do
      expect(@board.valid_placement?(@cruiser, %w[A1 A2])).to be false
      expect(@board.valid_placement?(@cruiser, %w[A1 A2 A3])).to be true
      expect(@board.valid_placement?(@submarine,
                                     %w[A2 A3 A4])).to be false
      expect(@board.valid_placement?(@submarine, %w[A2 A3])).to be true
    end

    it "has consecutive placement" do
      expect(@board.valid_placement?(@cruiser, %w[B1 C1 D1])).to be true # vertical
      expect(@board.valid_placement?(@cruiser, %w[B1 B2 B3])).to be true # horizontal
      expect(@board.valid_placement?(@cruiser, %w[A1 B2 C3])).to be false # diagonal
      expect(@board.valid_placement?(@cruiser, %w[A1 A2 A4])).to be false # not consecutive
    end

    it "can be in backwards order, so long as they are adjacent" do
      expect(@board.valid_placement?(@cruiser, %w[A3 A1 A2])).to be true
      expect(@board.valid_placement?(@cruiser, %w[C1 A1 B1])).to be true
    end
  end

  describe "#place_ship" do
    it "can place ship" do
      @board.place(@cruiser, %w[A1 A2 A3])

      @cell_1 = @board.cells["A1"]
      @cell_2 = @board.cells["A2"]
      @cell_3 = @board.cells["A3"]

      expect(@cell_1.ship).to eq(@cruiser)
      expect(@cell_2.ship).to eq(@cruiser)
      expect(@cell_3.ship).to eq(@cruiser)
      expect(@cell_3.ship == @cell_2.ship).to eq(true)
    end

    it "knows if a ship is overlapping" do
      @board.place(@cruiser, %w[A1 A2 A3])
      expect(@board.valid_placement?(@submarine, %w[A1 B1])).to be false
    end
  end

  describe "#rendering" do
    it "renders an empty board" do
      render = @board.render
      render_true = @board.render(true)
      expected = "  1 2 3 4 \n" \
                "A . . . . \n" \
                "B . . . . \n" \
                "C . . . . \n" \
                "D . . . . \n"
      expect(render).to eq(expected)
      expect(render_true).to eq(expected)
    end
    it "renders a board with ships on it" do
      @board.place(@cruiser, %w[A1 A2 A3])
      render = @board.render
      render_true = @board.render(true)

      expected_opponent = "  1 2 3 4 \n" \
                          "A . . . . \n" \
                          "B . . . . \n" \
                          "C . . . . \n" \
                          "D . . . . \n"

      expected_self = "  1 2 3 4 \n" \
                      "A S S S . \n" \
                      "B . . . . \n" \
                      "C . . . . \n" \
                      "D . . . . \n"

      expect(render).to eq(expected_opponent)
      expect(render_true).to eq(expected_self)
    end
  end
end
