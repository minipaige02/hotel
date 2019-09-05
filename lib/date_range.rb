require 'date'

module Hotel
  class DateRange
    attr_reader :check_in, :check_out

    def initialize(check_in, check_out)
      check_in = Date.strptime(check_in, "%m-%d-%Y")
      check_out = Date.strptime(check_out, "%m-%d-%Y")

      if check_in === check_out
        raise ArgumentError.new("Check-in date (#{check_in}) is equal to check-out date (#{check_out}).")
      elsif check_in > check_out
        raise ArgumentError.new("Check-in (#{check_in}) date cannot be after check-out date (#{check_out}).")
      else
        @check_in = check_in
        @check_out = check_out
      end
    end
    
    def total_nights
      @check_out - @check_in
    end

    #will check if date is in a date range
  end
end
