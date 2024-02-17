require "./spec/spec_helper"

# rubocop:disable Metrics/BlockLength
RSpec.describe Cell do
  before(:each) do
    @cell = Cell.new("B4")
    @cruiser = Ship.new("Cruiser", 3)
  end

  describe "#initialize" do
    it "exists and has attributes" do
      expect(@cell).to be_an_instance_of(Cell)
      expect(@cell.coordinate).to eq("B4")
      expect(@cell.ship).to eq(nil)
    end
  end

  describe "#place_ships" do
    it "is empty by default" do
      expect(@cell.empty?).to eq(true)
    end

    it "can have ships placed" do
      @cell.place_ship(@cruiser)
      expect(@cell.ship).to eq(@cruiser)
      expect(@cell.empty?).to eq(false)
    end
  end

  describe "#firing on the cell" do
    it "is not fired upon by default" do
      @cell.place_ship(@cruiser)
      expect(@cell.fired_upon?).to eq(false)
    end

    it "can be fired upon and hit ships" do
      @cell.place_ship(@cruiser)
      @cell.fire_upon
      expect(@cell.fired_upon?).to eq(true)
      expect(@cell.ship.health).to eq(2)
    end

    it "does nothing when fired upon twice" do
      @cell.place_ship(@cruiser)
      @cell.fire_upon
      @cell.fire_upon
      expect(@cell.fired_upon?).to eq(true)
      expect(@cell.ship.health).to eq(2)
    end

    it "does not throw an error when there is no ship" do
      @cell.fire_upon
      expect(@cell.fired_upon?).to eq(true)
      expect(@cell.ship.nil?).to eq(true)
    end
  end

  describe "#render cells" do
    it "renders '.' as default" do
      expect(@cell.render).to eq(".")
      @cell.place_ship(@cruiser)
      expect(@cell.render).to eq(".")
    end

    it "renders 'M' for a miss" do
      @cell.fire_upon
      expect(@cell.render).to eq("M")
    end

    it "renders 'S' when argument 'true' is provided" do
      @cell.place_ship(@cruiser)
      expect(@cell.render(true)).to eq("S")
    end

    it "renders 'H' when hit, regardless of argument" do
      @cell.place_ship(@cruiser)
      @cell.fire_upon
      expect(@cell.render).to eq("H")
      expect(@cell.render(true)).to eq("H")
    end

    it "renders 'X' when ship is sunk, regardless of argument" do
      @cell.place_ship(@cruiser)
      @cell.fire_upon
      @cell.ship.hit
      @cell.ship.hit
      expect(@cell.ship.sunk?).to eq(true)
      expect(@cell.render).to eq("X")
      expect(@cell.render(true)).to eq("X")
    end
    # These two tests are fail-safes for if a cell is somehow fired upon more than once.

    it "cannot hit a ship more than once" do
      @cell.place_ship(@cruiser)
      @cell.fire_upon
      @cell.fire_upon
      expect(@cell.ship.health).to eq(2)
    end

    it "does nothing when missed twice on same cell" do
      @cell.fire_upon
      @cell.fire_upon
      expect(@cell.render).to eq("M")
      expect(@cell.render(true)).to eq("M")
    end
  end
end
# rubocop:enable Metrics/BlockLength
