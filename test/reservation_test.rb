require_relative 'test_helper'

describe "Reservation" do
  describe "initialize" do
    before do
      date_range = Hotel::DateRange.new("05-22-2020", "05-24-2020")
      @reservation = Hotel::Reservation.new(date_range)
    end

    it "creates a reservation given a date" do
      expect(@reservation).must_be_instance_of Hotel::Reservation
    end
  end
end
