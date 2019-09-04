module Hotel
  class Room
    attr_reader :number, :cost_per_night

    COST_PER_NIGHT = 200
    
    def initialize(number)
        @number = number
        @cost_per_night = COST_PER_NIGHT
    end

    def self.all_rooms(total_rooms)
      rooms = []
      
      (1..total_rooms).each do |num|
        rooms << Hotel::Room.new(num)
      end

      return rooms
    end
  end
end
