require_relative 'test_helper'

describe "DateRange" do
  describe "initialize" do
    before do
      check_in = "04-05-2020"
      check_out = "04-16-2020"
      @date_range = Hotel::DateRange.new(check_in, check_out)
    end
    
    it "takes in a check_in date and a check_out date" do
      check_in = "03-02-2020"
      check_out = "03-22-2020"
      date_range2 = Hotel::DateRange.new(check_in, check_out)
      
      expect(date_range2).must_be_instance_of Hotel::DateRange
    end

    it "stores check_in date and check_out date as instances of Date" do
      expect(@date_range.check_in).must_be_instance_of Date
      expect(@date_range.check_out).must_be_instance_of Date
    end

    it "stores the correct check_in and check_out dates" do
      expect(@date_range.check_in.strftime("%m-%d-%Y")).must_equal "04-05-2020"
      expect(@date_range.check_out.strftime("%m-%d-%Y")).must_equal "04-16-2020"
    end
  end
  
  describe "valid_range?" do
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
  
  # it "calculates the number of nights in the range" do
  # end

end

