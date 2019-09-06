require 'date'

module Hotel
  class DateRange
    attr_reader :check_in, :check_out, :range

    def initialize(check_in, check_out)
      # refactor so only the range is stored and not the check-in & check-out dates?
      check_in = Date.strptime(check_in, "%m-%d-%Y")
      check_out = Date.strptime(check_out, "%m-%d-%Y")

      if check_in === check_out
        raise ArgumentError.new("Check-in date (#{check_in}) is equal to check-out date (#{check_out}).")
      elsif check_in > check_out
        raise ArgumentError.new("Check-in (#{check_in}) date cannot be after check-out date (#{check_out}).")
      else
        @check_in = check_in
        @check_out = check_out
        @range = create_range
      end
    end
    
    def create_range
      # check-out date is excluded from the date range since 
      # check-out time does not result in a conflict for reservations
      date_range = check_in...check_out
      date_range_array = date_range.to_a
    end

    def total_nights
      check_out - check_in
    end

    def date_included?(date)
      date = Date.strptime(date, "%m-%d-%Y")
      date >= check_in && date < check_out ? true : false
    end

    def overlaps?(other_dates)
      range[0] <= other_dates.range[-1] && other_dates.range[0] <= range[-1]
    end

  end
end
