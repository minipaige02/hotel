require_relative 'reservation'

module Hotel
  class SingleRes < Reservation
    attr_reader :room

    def initialize(date_range, room)
      super(date_range)
      @room = room
    end

    # Room should have a cost method. This calls on room's instance variable
    def cost
      (date_range.total_nights * room.cost_per_night).to_f
    end
  end
end
