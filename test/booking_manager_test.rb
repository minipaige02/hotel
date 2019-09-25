require_relative 'test_helper'

describe "BookingManager" do
  before do
    @booking_manager = Hotel::BookingManager.new(20)
  end
  
  describe "initialize" do
    it "creates an instance of BookingManager" do
      expect(@booking_manager).must_be_kind_of Hotel::BookingManager
    end
    
    it "stores an array of all the Rooms for the hotel" do
      expect(@booking_manager.rooms).must_be_kind_of Array
      expect(@booking_manager.rooms.length).must_equal 20
      @booking_manager.rooms.each do |room|
        expect(room).must_be_kind_of Hotel::Room
      end
    end
    
    it "stores and array of Reservations" do
      # this is room number 4
      date_range1 = Hotel::DateRange.new("05-22-2020", "05-24-2020")
      test_room1 = @booking_manager.rooms[3]
      reservation1 = Hotel::SingleRes.new(date_range1, test_room1)
      # this is room number 5
      test_room2 = @booking_manager.rooms[4]
      date_range2 = Hotel::DateRange.new("05-23-2020", "05-25-2020")
      reservation2 = Hotel::SingleRes.new(date_range2, test_room2)

      @booking_manager.reservations << reservation1
      @booking_manager.reservations << reservation2

      expect(@booking_manager.reservations).must_be_kind_of Array
      expect(@booking_manager.reservations.length).must_equal 2
      @booking_manager.reservations.each do |reservation|
        expect(reservation).must_be_kind_of Hotel::SingleRes
      end
    end
  end

  describe "list all rooms" do
    it "returns a string of room numbers" do
      booking_manager2 = Hotel::BookingManager.new(2)

      expect(booking_manager2.list_rooms).must_be_kind_of String
      expect(booking_manager2.list_rooms).must_equal "Room 1\nRoom 2"
    end
  end

  describe "find reservations by date" do
    before do
      @booking_manager2 = Hotel::BookingManager.new(5)
      test_room3 = @booking_manager.rooms[0]
      date_range3 = Hotel::DateRange.new("05-23-2020", "05-25-2020")
      reservation3 = Hotel::SingleRes.new(date_range3, test_room3)

      test_room4 = @booking_manager.rooms[2]
      date_range4 = Hotel::DateRange.new("05-24-2020", "05-27-2020")
      reservation4 = Hotel::SingleRes.new(date_range4, test_room4)

      @booking_manager2.reservations << reservation3
      @booking_manager2.reservations << reservation4
    end
    
    it "returns an array of reservations for a specific date" do
      test_search = @booking_manager2.list_reservations("05-24-2020")
      test_search2 = @booking_manager2.list_reservations("05-23-2020")

      expect(test_search).must_be_kind_of Array
      expect(test_search.length).must_equal 2
      expect(test_search2.length).must_equal 1
      test_search.each do |reservation|
        expect(reservation).must_be_instance_of Hotel::SingleRes
      end
    end
    
    it "returns an array of accurate reservations for a specific date" do
      test_search = @booking_manager2.list_reservations("05-24-2020")

      expect(test_search[0].room.number).must_equal 1
      expect(test_search[0].date_range.check_out.strftime("%m-%d-%Y")).must_equal "05-25-2020"
      expect(test_search[1].room.number).must_equal 3
      expect(test_search[1].date_range.check_out.strftime("%m-%d-%Y")).must_equal "05-27-2020"
    end

    it "returns nil if no reservations are found" do
      expect(@booking_manager2.list_reservations("05-22-2020")).must_be_nil
      expect(@booking_manager2.list_reservations("06-22-2020")).must_be_nil
      expect(@booking_manager2.list_reservations("05-27-2020")).must_be_nil
    end

    it "returns both single reservations and blocks" do
      rooms = [@booking_manager2.rooms[1], @booking_manager2.rooms[3]]
      block_res = Hotel::BlockRes.new(
        date_range: Hotel::DateRange.new("05-23-2020", "05-25-2020"), rooms: rooms, 
        discount: 0.15, 
        group_name: "SAA"
      )
      @booking_manager2.blocks << block_res

      found_reservations = @booking_manager2.list_reservations("05-24-2020")

      expect(found_reservations.length).must_equal 3
      expect(found_reservations[2]).must_be_instance_of Hotel::BlockRes
    end
  end

  describe "rooms available" do
    before do
      reservation1 = Hotel::SingleRes.new(
        Hotel::DateRange.new("05-22-2020", "05-24-2020"), 
        @booking_manager.rooms[0]) #this is room 1
      reservation2 = Hotel::SingleRes.new(
        Hotel::DateRange.new("05-22-2020", "05-24-2020"), 
        @booking_manager.rooms[1]) #this is room 2
      reservation3 = Hotel::SingleRes.new(
        Hotel::DateRange.new("05-25-2020", "05-27-2020"), 
        @booking_manager.rooms[2]) #this is room 3
      reservation4 = Hotel::SingleRes.new(
        Hotel::DateRange.new("06-03-2020", "06-05-2020"), 
        @booking_manager.rooms[7]) #this is room 8
      block_res = Hotel::BlockRes.new(
        date_range: Hotel::DateRange.new("06-03-2020", "06-05-2020"), 
        rooms: [ #rooms 3-7
          @booking_manager.rooms[2], 
          @booking_manager.rooms[3], 
          @booking_manager.rooms[4],
          @booking_manager.rooms[5],
          @booking_manager.rooms[6]
          ],
        discount: 0.15,
        group_name: "SAA"
      )
      
      @booking_manager.reservations << reservation1
      @booking_manager.reservations << reservation2
      @booking_manager.reservations << reservation3
      @booking_manager.reservations << reservation4
      @booking_manager.blocks << block_res
    end

    it "returns an array of available rooms for a given date range" do
      check_in = "05-23-2020"
      check_out = "05-25-2020"

      availability = @booking_manager.rooms_available(check_in, check_out)
      
      expect(availability.length).must_equal 18
      availability.each do |room|
        expect(room).must_be_instance_of Hotel::Room
      end
    end

    it "returns an accurate list of available rooms" do
      check_in = "05-23-2020"
      check_out = "05-25-2020"

      availability = @booking_manager.rooms_available(check_in, check_out)
      room_numbers = availability.map {|room| room.number}

      expect(room_numbers).wont_include 1
      expect(room_numbers).wont_include 2
      expect(room_numbers).must_include 3
      expect(room_numbers).must_include 20
    end

    it "does not include rooms set aside for a block" do
      availability = @booking_manager.rooms_available("06-04-2020", "06-07-2020")
      room_numbers = availability.map {|room| room.number}
      
      expect(availability.length).must_equal 14
      expect(room_numbers).wont_include 5
      expect(room_numbers).wont_include 8
    end
  end

  describe "book single reservation" do
    before do
      @booking_manager3 = Hotel::BookingManager.new(3)
      reservation1 = Hotel::SingleRes.new(
        Hotel::DateRange.new("09-01-2020", "09-24-2020"), 
        @booking_manager3.rooms[0])
      reservation2 = Hotel::SingleRes.new(
        Hotel::DateRange.new("09-01-2020", "09-07-2020"), 
        @booking_manager3.rooms[1])
      reservation3 = Hotel::SingleRes.new(
        Hotel::DateRange.new("09-01-2020", "09-07-2020"), 
        @booking_manager3.rooms[2])

      @booking_manager3.reservations << reservation1
      @booking_manager3.reservations << reservation2
      @booking_manager3.reservations << reservation3
    end

    it "adds the new reservation to BookingManager" do
      @booking_manager3.book_single_res("09-08-2020", "09-10-2020")

      all_reservations = @booking_manager3.reservations

      expect(all_reservations.length).must_equal 4
    end
    
    it "will not book a room that is not available" do
      @booking_manager3.book_single_res("09-08-2020", "09-10-2020")
      
      expect(@booking_manager3.reservations[3].room.number).wont_equal 1 
    end

    it "raises an error if no rooms are available for the given date range" do 
      check_in = "09-02-2020"
      check_out = "09-10-2020"

      expect{@booking_manager3.book_single_res(check_in, check_out)}.must_raise ArgumentError
    end

    it "won't allow reservation to be made for a room reserved for a hotel block" do
      @booking_manager3.create_block(
        check_in: "10-08-2020", 
        check_out: "10-10-2020", 
        total_rooms: 3, 
        group_name: "Davenport", 
        discount: 0.10
      )

      expect{@booking_manager3.book_single_res("10-09-2020", "10-11-2020")}.must_raise ArgumentError
    end
  end

  describe "create block reservation" do
    before do
      @booking_manager = Hotel::BookingManager.new(5)
    end 

    it "adds an instance of BlockRes to the booking manager's list of blocks" do
      new_block = @booking_manager.create_block(check_in: "08-01-2020", check_out: "08-04-2020", total_rooms: 3, group_name: "SAA", discount: 0.15)

      expect(@booking_manager.blocks.length).must_equal 1
    end

    it "raises an exception if the total rooms requested exceeds the number of available rooms" do
      @booking_manager.book_single_res("06-05-2020", "06-10-2020")

      expect{@booking_manager.create_block(
        check_in: "06-09-2020",
        check_out: "06-12-2020",
        total_rooms: 5,
        group_name: "SAA",
        discount: 0.10
      )}.must_raise ArgumentError
    end

    it "raises an exception if the total rooms requested exceeds 5" do
      expect{@booking_manager.create_block(
        check_in: "06-09-2020",
        check_out: "06-12-2020",
        total_rooms: 6,
        group_name: "SAA",
        discount: 0.10
      )}.must_raise ArgumentError
    end

    it "cannot create a block with a room that's part of another block" do
      @booking_manager.create_block(
        check_in: "07-01-2020",
        check_out: "07-03-2020",
        total_rooms: 3,
        group_name: "SAA",
        discount: 0.10
      )
      @booking_manager.create_block(
        check_in: "07-01-2020",
        check_out: "07-03-2020",
        total_rooms: 2,
        group_name: "SCA",
        discount: 0.10
      )

      block1_rooms = @booking_manager.blocks[0].rooms.map! {|room|
        room.number}
      block2_rooms = @booking_manager.blocks[1].rooms.map! {|room|
        room.number}

      expect(block1_rooms).wont_include block2_rooms[0]
      expect(block1_rooms).wont_include block2_rooms[1]
    end
  end

  describe "find block" do
    before do
      @booking_manager.create_block(
        check_in: "10-10-2020", 
        check_out: "10-15-2020", 
        total_rooms: 3, 
        group_name: "Ramoz", 
        discount: 0.10
      )
    end

    it "can find a block given a group name" do
      found_block = @booking_manager.find_block("Ramoz")

      expect(found_block).must_equal @booking_manager.blocks[0]
    end

    it "returns nil if no blocks found" do
      found_block = @booking_manager.find_block("SAA")

      expect(found_block).must_be_nil
    end
  end

  describe "book block res" do
    before do 
      @booking_manager.create_block(
        check_in: "10-10-2020", 
        check_out: "10-15-2020", 
        total_rooms: 3, 
        group_name: "Ramoz", 
        discount: 0.10
      )

      @block_res = @booking_manager.blocks[0]
    end

    it "shortens the block's number of unreserved rooms by 1" do
      @booking_manager.book_block_res("Ramoz")
      unreserved_room_nums = @block_res.unreserved_rooms.map {|room| room.number}
      
      expect(@booking_manager.blocks.length).must_equal 1
      expect(@block_res.unreserved_rooms.length).must_equal 2
      expect(@block_res.rooms.length).must_equal 3
      expect(unreserved_room_nums).wont_include 1
      expect(unreserved_room_nums).must_include 2 
      expect(unreserved_room_nums).must_include 3
    end

    it "raises an exception if no rooms are available from the block" do
      3.times do 
        @booking_manager.book_block_res("Ramoz")
      end

      expect{@booking_manager.book_block_res("Ramoz")}.must_raise ArgumentError
    end
  end
end
