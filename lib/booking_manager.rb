require_relative 'room'
require_relative 'single_res'
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

    def rooms_available(start_date, end_date)
      reserved_rooms = reservations.select do |reservation|
        reservation.date_range.overlaps?(start_date, end_date)
      end.map {|reservation| reservation.room}

      available_rooms = rooms - reserved_rooms

      return available_rooms
    end

    def find_rooms(available_rooms, total_rooms = 1)
      if total_rooms == 1
        return available_rooms[0]
      else
        rooms = []
        total_rooms.times do
          rooms << available_rooms.shift
        end
        return rooms
      end
    end

    def book_single_res(check_in, check_out)
      available_rooms = rooms_available(check_in, check_out)
      dates = Hotel::DateRange.new(check_in, check_out)
      
      if available_rooms.length == 0
        raise ArgumentError.new("No available rooms for #{check_in} - #{check_out}")
      else
        room = find_rooms(available_rooms)
        reservations << Hotel::SingleRes.new(dates, room)
      end
    end

    # def book_block_res(check_in:, check_out:, total_rooms:, group:, discount:)
    #   # raises error if try to set aside more than 5 rooms
    #   if total_rooms > 5
    #     raise ArgumentError.new("Total rooms in block cannot exceed 5 rooms.")
    #   end

    #   available_rooms = rooms_available(check_in, check_out)
    #   dates = Hotel::DateRange.new(check_in, check_out)

    #   if available_rooms.length < total_rooms
    #     raise ArgumentError.new("Insufficient rooms available for #{check_in} - #{check_out}.")
    #   else
    #     rooms = []
    #     total_rooms.times do 
    #       rooms << find_room(available_rooms)
    #     end
      

    # end
  end
end
