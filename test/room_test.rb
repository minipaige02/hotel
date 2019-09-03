require_relative 'test_helper'

describe "Room class" do
  describe "initialize" do
    before do
      rm_number = 5
      @room = Hotel::Room.new(rm_number)
    end

    it "creates an istance of Room" do
      expect(@room).must_be_kind_of Hotel::Room
    end

    it "stores a room number" do
      expect(@room.number).must_be_kind_of Integer
      expect(@room.number).must_equal 5
    end

    it "stores the value of 200 for cost per night" do
      expect(@room.cost_per_night).must_equal 200
    end
  end
end
