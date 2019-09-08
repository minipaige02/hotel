require_relative 'test_helper'

describe "BlockRes" do
  before do
    @booking_manager = Hotel::BookingManager.new(10)

  end
  describe "initialize" do
    it "creates a block of reservations with a date range, group of rooms, and a discounted room rate" do
      date_range = Hotel::DateRange.new("07-17-2020", "07-24-2020")
      rooms = [@booking_manager.rooms[0], @booking_manager.rooms[1], @booking_manager.rooms[2]]
      discount = 0.15
      group = "Davenport"

      new_block = Hotel::BlockRes.new(date_range: date_range, rooms: rooms, discount: discount, group_name: group)

      expect(new_block).must_be_instance_of Hotel::BlockRes
    end

    it "stores accurate information about the block" do
      date_range = Hotel::DateRange.new("07-17-2020", "07-24-2020")
      rooms = [@booking_manager.rooms[0], @booking_manager.rooms[1], @booking_manager.rooms[2]]
      discount = 0.15
      group = "Davenport"

      new_block = Hotel::BlockRes.new(date_range: date_range, rooms: rooms, discount: discount, group_name: group)

      room_numbers = new_block.rooms.map {|room| room.number}

      expect(new_block.rooms.length).must_equal 3
      expect(room_numbers).must_include 2
      expect(room_numbers).wont_include 4
      expect(new_block.discount).must_equal 0.15
      expect(new_block.date_range.check_in.strftime("%m-%d-%Y")).must_equal "07-17-2020"
    end
  end

  describe "rooms available?" do
    before do
      @block = Hotel::BlockRes.new(
        date_range: Hotel::DateRange.new("07-17-2020", "07-24-2020"),
        rooms: [
          @booking_manager.rooms[0], 
          @booking_manager.rooms[1], 
          @booking_manager.rooms[2], 
          @booking_manager.rooms[4]
         ],
        discount: 0.10, 
        group_name: "SAA"
      )
    end

    it "returns true if block has rooms that have not been booked" do
      @block.unreserved_rooms.delete(@booking_manager.rooms[0])

      expect(@block.unreserved_rooms.length).must_equal 3
      expect(@block.rooms_available?).must_equal true
    end

    it "returns false if all the rooms have been booked" do
      @block.unreserved_rooms.clear

      expect(@block.rooms_available?).must_equal false
      expect(@block.rooms.length).must_equal 4
    end
  end

end
