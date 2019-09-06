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
    
    def find_reservations_by_date(date)
      found_reservations = @reservations.select do |reservation|
        reservation.date_range.date_included?(date)
      end
      
      if found_reservations.length == 0
        nil
      else
        return found_reservations
      end 
    end

    def rooms_available(check_in, check_out)
      dates_to_check = Hotel::DateRange.new(check_in, check_out)

      reserved_rooms = reservations.select do |reservation|
        reservation.date_range.overlaps?(dates_to_check)
      end.map {|reservation| reservation.room}

      available_rooms = rooms - reserved_rooms

      return available_rooms
    end
    
    
    
    #make a reservation for a given date range(initialize date_range)
    #NO DATE OVERLAP!
    #raise exception if try to book a room when all rooms are booked
  end
end
