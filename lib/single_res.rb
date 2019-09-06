require_relative 'reservation'

module Hotel
  class SingleRes < Reservation
    attr_reader :room

    def initialize(date_range, room)
      super(date_range)
      @room = room
      #@id = 
    end

    def total_cost
      (date_range.total_nights * room.cost_per_night).to_f
    end
    
  end
end
