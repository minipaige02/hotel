module Hotel
  class Room
    attr_reader :number, :cost_per_night
    
    def initialize(number, cost_per_night = 200)
        @number = number
        @cost_per_night = cost_per_night
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
