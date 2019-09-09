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
      check_out - check_in
    end

    def date_included?(date)
      date = Date.strptime(date, "%m-%d-%Y")
      date >= check_in && date < check_out ? true : false
    end

    def overlaps?(start_date, end_date)
      start_date = Date.strptime(start_date, "%m-%d-%Y")
      end_date = Date.strptime(end_date, "%m-%d-%Y")

      check_in <= (end_date - 1) && start_date <= (check_out - 1)
    end
  end
end
