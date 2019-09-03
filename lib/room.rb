module Hotel
  class Room
    attr_reader :number, :cost_per_night
    
    def initialize(number)
        @number = number
        @cost_per_night = 200
    end
  end
end
