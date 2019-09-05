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
      reservation1 = Hotel::Reservation.new(date_range1, test_room1)
      # this is room number 5
      test_room2 = @booking_manager.rooms[4]
      date_range2 = Hotel::DateRange.new("05-23-2020", "05-25-2020")
      reservation2 = Hotel::Reservation.new(date_range2, test_room2)

      @booking_manager.reservations << reservation1
      @booking_manager.reservations << reservation2

      expect(@booking_manager.reservations).must_be_kind_of Array
      expect(@booking_manager.reservations.length).must_equal 2
      @booking_manager.reservations.each do |reservation|
        expect(reservation).must_be_kind_of Hotel::Reservation
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
end
