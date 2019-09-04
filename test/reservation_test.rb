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



end
