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

  describe "find reservations by date" do
    before do
      @booking_manager2 = Hotel::BookingManager.new(5)
      test_room3 = @booking_manager.rooms[0]
      date_range3 = Hotel::DateRange.new("05-23-2020", "05-25-2020")
      reservation3 = Hotel::Reservation.new(date_range3, test_room3)

      test_room4 = @booking_manager.rooms[2]
      date_range4 = Hotel::DateRange.new("05-24-2020", "05-27-2020")
      reservation4 = Hotel::Reservation.new(date_range4, test_room4)

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
        expect(reservation).must_be_instance_of Hotel::Reservation
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
      expect(@booking_manager2.find_reservations_by_date("05-22-2020")).must_equal nil
      expect(@booking_manager2.find_reservations_by_date("06-22-2020")).must_equal nil
      expect(@booking_manager2.find_reservations_by_date("05-27-2020")).must_equal nil
    end

  end

end
