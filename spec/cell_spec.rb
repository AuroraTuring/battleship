require "./spec/spec_helper"

RSpec describe Cell do
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

end
