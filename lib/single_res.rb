require_relative 'reservation'

module Hotel
  class SingleRes < Reservation
    attr_reader :room

    def initialize(date_range, room)
      super(date_range)
      @room = room
    end

    def cost
      (date_range.total_nights * room.cost).to_f
    end
  end
end
