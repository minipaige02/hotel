require 'date'

module Hotel
  class DateRange
    attr_reader :check_in, :check_out

    def initialize(check_in, check_out)
      @check_in = Date.strptime(check_in, "%m-%d-%Y")
      @check_out = Date.strptime(check_out, "%m-%d-%Y")
    end
    
    #will check if date is in a date range
  end
end
