module Hotel
  class BlockRes < Reservation
    attr_reader :rooms, :discount, :group_name
    attr_accessor :unreserved_rooms

    def initialize(date_range:, rooms:, discount:, group_name:)
      super(date_range)
      @rooms = rooms
      @unreserved_rooms = rooms.dup
      @discount = discount
      @group_name = group_name
    end

    def rooms_available?
      unreserved_rooms.length > 0 ? true : false
    end

    def cost(room)
      if !rooms.include?(room)
        raise ArgumentError.new("Invalid room entered.")
      end
      return (date_range.total_nights * room.cost).to_f * (1 - discount)
    end
  end
end
