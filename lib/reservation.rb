require_relative 'date_range'

module Hotel
  class Reservation
    attr_reader :date_range, :room

    def initialize(date_range, room)
      @date_range = date_range
      @room = room
      #@id = 
    end

    def total_cost
      (@date_range.total_nights * @room.cost_per_night).to_f
    end
    
  end
end
