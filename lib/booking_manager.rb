require_relative 'room'
require_relative 'single_res'
require_relative 'block_res'
require_relative 'date_range'

module Hotel
  class BookingManager
    attr_reader :rooms, :reservations, :blocks
    
    def initialize(total_rooms)
      @rooms = Hotel::Room.all_rooms(total_rooms)
      @reservations = []
      @blocks = []
    end
    
    def list_rooms
      room_list = @rooms.map do |room|
        "Room #{room.details}"
      end.join("\n")
      
      return room_list
    end

    def list_reservations(date)
      found_singles = reservations.select do |reservation|
        reservation.date_included?(date)
      end

      found_blocks = blocks.select do |block|
        block.date_included?(date)
      end

      found_reservations = found_singles + found_blocks
      
      if found_reservations.length == 0
        nil
      else
        return found_reservations
      end 
    end

    def rooms_available(start_date, end_date)
      reserved_single = reservations.select do |reservation|
        reservation.overlaps?(start_date, end_date)
      end.map! {|reservation| reservation.room}

      reserved_blocks = blocks.select do |block|
        block.overlaps?(start_date, end_date)
      end.map! {|block| block.unreserved_rooms}

      all_reserved = reserved_single + reserved_blocks.flatten!.to_a
      
      available_rooms = rooms - all_reserved

      return available_rooms
    end

    def book_single_res(check_in, check_out)
      available_rooms = rooms_available(check_in, check_out)
      dates = Hotel::DateRange.new(check_in, check_out)
      
      if available_rooms.length == 0
        raise ArgumentError.new("No available rooms for #{check_in} - #{check_out}")
      else
        room = available_rooms[0]
        reservations << Hotel::SingleRes.new(dates, room)
      end
    end
    
    def create_block(check_in:, check_out:, total_rooms:, group_name:, discount:)
      if total_rooms > 5
        raise ArgumentError.new("Total rooms in block cannot exceed 5 rooms.")
      end
      
      available_rooms = rooms_available(check_in, check_out)
      dates = Hotel::DateRange.new(check_in, check_out)
      
      if available_rooms.length < total_rooms
        raise ArgumentError.new("Insufficient rooms available for #{check_in} - #{check_out}.")
      else
        rooms = []
        total_rooms.times do
          rooms << available_rooms.shift
        end

        blocks << Hotel::BlockRes.new(
          date_range: dates, 
          rooms: rooms, 
          discount: discount, 
          group_name: group_name
        )
      end
    end
    
    def find_block(group_name)
      blocks.each do |block|
        if block.group_name == group_name
          return block
        end
      end
      return nil
    end

    def book_block_res(group_name)
      block = find_block(group_name)

      if block.rooms_available?
        block.reserve_room
      else
        raise ArgumentError.new("No rooms availalbe.")
      end
    end
  end
end
