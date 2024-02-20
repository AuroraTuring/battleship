require "./spec/spec_helper"

RSpec.describe Game do
  before(:each) do
    @game = Game.new
    @player_board = Board.new
    @computer_board = Board.new
  end

  describe "#initialization" do
    it "exists" do
      expect(@game).to be_an_instance_of(Game)
    end
    it "initializes attributes" do
      expect(@game.player_board).to eq(nil)
      expect(@game.computer_board).to eq(nil)
      expect(@game.game_in_progress).to eq(false)
    end
  end

  describe "#place computer ships" do
    it "can place random ship locations" do
    end
  end
end
