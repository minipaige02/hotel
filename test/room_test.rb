require_relative 'test_helper'

describe "Room class" do
  before do
    @room = Hotel::Room.new(5)
  end

  it "Creates an istance of Room" do
    expect(@room).must_be_kind_of Hotel::Room
  end

  it "Stores a room number" do
    expect(@room.number).must_be_kind_of Integer
  end

  it "Stores the value of 200 for cost per night" do
    expect(@room.cost_per_night).must_equal 200
  end
end
