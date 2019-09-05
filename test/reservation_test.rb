require_relative 'test_helper'

describe "Reservation" do
  describe "initialize" do
    before do
      @room = Hotel::Room.new(11)
      @date_range = Hotel::DateRange.new("05-22-2020", "05-24-2020")
      @reservation = Hotel::Reservation.new(@date_range, @room)
    end

    it "creates a reservation given a date" do
      expect(@reservation).must_be_instance_of Hotel::Reservation
    end

    it "stores one instance of Room and one instance of Reservation" do
      expect(@reservation.room).must_be_instance_of Hotel::Room
      expect(@reservation.date_range).must_be_instance_of Hotel::DateRange
    end

    it "stores accurate information about the reservation" do
      expect(@reservation.room.number).must_equal 11
      expect(@reservation.date_range.check_out.strftime("%m-%d-%Y")).must_equal "05-24-2020"
    end
  end

  describe "total cost" do
    it "calculates the total cost for a reservation" do
      test_room = Hotel::Room.new(13)
      date_range1 = Hotel::DateRange.new("05-01-2020", "05-02-2020")
      date_range2 = Hotel::DateRange.new("06-10-2020", "06-22-2020")
    
      reservation1 = Hotel::Reservation.new(date_range1, test_room)
      reservation2 = Hotel::Reservation.new(date_range2, test_room)
      
      expect(reservation1.total_cost).must_be_kind_of Float
      expect(reservation1.total_cost).must_be_close_to 200.0, 0.01 
      expect(reservation2.total_cost).must_be_close_to 2400.0, 0.01
    end
  end


end
