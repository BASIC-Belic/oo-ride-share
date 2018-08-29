module RideShare

  class Driver < User
    attr_reader :vehicle_id, :driven_trips, :status


    def initialize(input)
      super(input)
      #user has access to id, name, phone_number
      #so does driver
      # unless input[:status] == :UNAVAILABLE || input[:status] == :AVAILABLE
      #   raise ArgumentError.new("TEST")
      # end

      @vehicle_id = input[:vin]
      @status = input[:status]


      raise ArgumentError.new() unless [:UNAVAILABLE, :AVAILABLE].include?(@status)

      raise ArgumentError.new() unless @vehicle_id.length == 17
      # if input[:vin].length !=17
      #   raise ArgumentError, 'error'
      # end
    end



  end
end
