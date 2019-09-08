module Hotel
  class BlockRes < Reservation
    attr_reader :rooms, :discount, :group_name, :unreserved_rooms

    def initialize(date_range:, rooms:, discount:, group_name:)
      super(date_range)
      @rooms = rooms
      @unreserved_rooms = rooms
      @discount = discount
      @group_name = group_name
    end

    #needs to know if rooms has been booked or not
    #check calculation
    def cost(room)
      #room must be included in @rooms
      # super: (date_range.total_nights * room.cost_per_night).to_f * discount
    end
  end
end
