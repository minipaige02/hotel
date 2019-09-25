module Hotel
  class Room
    COST_PER_NIGHT = 200
    attr_reader :number, :cost_per_night
    
    def initialize(number)
        @number = number
    end

    def self.all_rooms(total_rooms)
      rooms = []
      
      (1..total_rooms).each do |num|
        rooms << Hotel::Room.new(num)
      end

      return rooms
    end

    def cost
      return COST_PER_NIGHT
    end

    def details
      return number
    end
  end
end
