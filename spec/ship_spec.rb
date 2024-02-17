require "spec/spec_helper"

RSpec.describe Ship do
  before(:each) do
    @cruiser = Ship.new("Cruiser", 3)
  end

  describe "#initialize" do
    it "exists and has attributes" do
      expect(@cruiser).to be_an_instance_of(Ship)
      expect(@cruiser.name).to eq("Cruiser")
      expect(@cruiser.length).to eq(3)
      expect(@cruiser.health).to eq(3)
    end
  end

  describe "#hit and sunk" do
    it "is not sunk by default" do
      expect(@cruiser.sunk?).to eq(false)
    end
    it "can be hit" do
      @cruiser.hit
      expect(@cruiser.health).to eq(2)
      expect(@cruiser.sunk?).to eq(false)
      @cruiser.hit
      expect(@cruiser.health).to eq(1)
      expect(@cruiser.sunk?).to eq(false)
    end
  end
end
