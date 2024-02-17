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

end
