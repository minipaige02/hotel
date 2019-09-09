require_relative 'date_range'

module Hotel
  class Reservation
    attr_reader :date_range

    def initialize(date_range)
      @date_range = date_range
    end

    def cost
      raise NotImplementedError
    end
  end
end
