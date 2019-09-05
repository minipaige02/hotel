require_relative 'room'
require_relative 'reservation'
require_relative 'date_range'

module Hotel
  class BookingManager
    attr_reader :rooms, :reservations

    def initialize(total_room_count)
      @rooms = Hotel::Room.all_rooms(total_room_count)
      @reservations = []
    end

    def list_all_rooms
      room_list = @rooms.map do |room|
        "Room #{room.number}"
      end.join("\n")
    
      return room_list
    end
  end
end
