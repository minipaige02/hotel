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

      expect(booking_manager2.list_all_rooms).must_be_kind_of String
      expect(booking_manager2.list_all_rooms).must_equal "Room 1\nRoom 2"
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
      test_search = @booking_manager2.find_reservations_by_date("05-24-2020")
      test_search2 = @booking_manager2.find_reservations_by_date("05-23-2020")

      expect(test_search).must_be_kind_of Array
      expect(test_search.length).must_equal 2
      expect(test_search2.length).must_equal 1
      test_search.each do |reservation|
        expect(reservation).must_be_instance_of Hotel::SingleRes
      end
    end
    
    it "returns an array of accurate reservations for a specific date" do
      test_search = @booking_manager2.find_reservations_by_date("05-24-2020")

      expect(test_search[0].room.number).must_equal 1
      expect(test_search[0].date_range.check_out.strftime("%m-%d-%Y")).must_equal "05-25-2020"
      expect(test_search[1].room.number).must_equal 3
      expect(test_search[1].date_range.check_out.strftime("%m-%d-%Y")).must_equal "05-27-2020"
    end

    it "returns nil if no reservations are found" do
      expect(@booking_manager2.find_reservations_by_date("05-22-2020")).must_be_nil
      expect(@booking_manager2.find_reservations_by_date("06-22-2020")).must_be_nil
      expect(@booking_manager2.find_reservations_by_date("05-27-2020")).must_be_nil
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
      
      @booking_manager.reservations << reservation1
      @booking_manager.reservations << reservation2
      @booking_manager.reservations << reservation3
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
  end

  describe "book reservation" do
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
      @booking_manager3.book_reservation("09-08-2020", "09-10-2020")

      all_reservations = @booking_manager3.reservations

      expect(all_reservations.length).must_equal 4
    end
    
    it "will not book a room that is not available" do
      @booking_manager3.book_reservation("09-08-2020", "09-10-2020")
      
      expect(@booking_manager3.reservations[3].room.number).wont_equal 1 
    end

    it "raises an error if no rooms are available for the given date range" do 
      check_in = "09-02-2020"
      check_out = "09-10-2020"

      expect{@booking_manager3.book_reservation(check_in, check_out)}.must_raise ArgumentError
    end
  end
end
