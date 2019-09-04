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

  describe "self.all_rooms" do
    before do
      @rooms = Hotel::Room.all_rooms(20)
    end

    it "returns an array of Rooms" do
      expect(@rooms).must_be_kind_of Array
      expect(@rooms.length).must_equal 20
      @rooms.each do |room|
        expect(room).must_be_kind_of Hotel::Room
      end
    end
  end

end
