module Hotel
  class BlockRes < Reservation
    attr_reader :rooms, :discount, :group
    attr_accessor :unbooked_rooms

    def initialize(date_range:, rooms:, discount:, group:)
      super(date_range)
      @rooms = rooms
      @discount = discount
      @group = group
      @unbooked_rooms = rooms
      #generates list of reservations to add to booking manager?
    end
    #should hold a list of reservations?
    #should hold a group name?

    #needs to know if rooms has been booked or not


    #make factory of reservation
    #then single and block child classes
  

  end

  #method to find which books are reserved?
end
