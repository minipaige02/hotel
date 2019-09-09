require_relative 'test_helper'

describe "DateRange" do
  describe "initialize" do
    before do
      check_in = "04-05-2020"
      check_out = "04-16-2020"
      @date_range = Hotel::DateRange.new(check_in, check_out)
    end
    
    it "takes in a check-in date and a check-out date" do
      check_in = "03-02-2020"
      check_out = "03-22-2020"
      date_range2 = Hotel::DateRange.new(check_in, check_out)
      
      expect(date_range2).must_be_instance_of Hotel::DateRange
    end
    
    it "stores check-in date and check-out date as instances of Date" do
      expect(@date_range.check_in).must_be_instance_of Date
      expect(@date_range.check_out).must_be_instance_of Date
    end
    
    it "stores the correct check_in and check_out dates" do
      expect(@date_range.check_in.strftime("%m-%d-%Y")).must_equal "04-05-2020"
      expect(@date_range.check_out.strftime("%m-%d-%Y")).must_equal "04-16-2020"
    end
  end
  
  describe "valid range?" do
    it "raises an ArgumentError when check_out date is before check_in date" do
      expect{ Hotel::DateRange.new("03-04-2020", "03-03-2020") }.must_raise ArgumentError
    end
    
    it "raises an ArgumentError if check_out and check_in date are the same" do
      expect{ Hotel::DateRange.new("03-04-2020", "03-04-2020") }.must_raise ArgumentError
    end
    
    it "raises an ArgumentError if check_in/check_out date is not in a valid format" do
      expect{ Hotel::DateRange.new("Monday", "03-04-2020") }.must_raise ArgumentError
      expect{ Hotel::DateRange.new("03-2020", "03-04-2020") }.must_raise ArgumentError
    end
  end
  
  describe "total nights" do
    it "calculates the number of nights in the range" do
      date_range1 = Hotel::DateRange.new("04-17-2020", "04-20-2020")
      date_range2 = Hotel::DateRange.new("12-21-2019", "01-01-2020")
      date_range3 = Hotel::DateRange.new("02-27-2020", "03-02-2020")

      expect(date_range1.total_nights).must_equal 3
      expect(date_range2.total_nights).must_equal 11
      expect(date_range3.total_nights).must_equal 4
    end
  end

  describe "date included?" do
    before do
      @date_range4 = Hotel::DateRange.new("07-01-2020", "07-07-2020")
    end

    it "returns true if a given date is included in the date range" do
      expect(@date_range4.date_included?("07-05-2020")).must_equal true
    end

    it "returns false if a given date is not included in the date range" do
      expect(@date_range4.date_included?("05-07-2020")).must_equal false
    end

    it "returns false if a given date is the same as the check-out date" do
      expect(@date_range4.date_included?("07-07-2020")).must_equal false
    end
  end

  describe "overlaps?" do
    before do
      @range1 = Hotel::DateRange.new("08-01-2020", "08-05-2020")
      @range2 = Hotel::DateRange.new("07-31-2020", "08-02-2020")
      @range3 = Hotel::DateRange.new("08-05-2020", "08-08-2020")
      @range4 = Hotel::DateRange.new("08-01-2020", "08-05-2020")
    end

    it "returns true if two date ranges overlap" do
      expect(@range1.overlaps?("07-31-2020", "08-02-2020")).must_equal true
      expect(@range2.overlaps?("08-01-2020", "08-05-2020")).must_equal true
    end

    it "returns false if two date ranges do not overlap" do
      expect(@range2.overlaps?("08-05-2020", "08-08-2020")).must_equal false
      expect(@range3.overlaps?("07-31-2020", "08-02-2020")).must_equal false
    end

    it "returns false if a date range's check-out date is the same as another range's check-in date" do
      expect(@range1.overlaps?("08-05-2020", "08-08-2020")).must_equal false
      expect(@range3.overlaps?("08-01-2020", "08-05-2020")).must_equal false
    end

    it "returns true if date ranges match" do
      expect(@range1.overlaps?("08-01-2020", "08-05-2020")).must_equal true
    end
  end
end

