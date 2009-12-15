module ConferenceCallService

  
  class ConferenceDetails
    attr_accessor :name, :description, :duration

    # Constructor
    def initialize(name, description, duration)
      @name         = name
      @description  = description
      @duration     = duration
    end

    def to_s
      "#{@name.to_s} - #{@description.to_s}: #{@duration.to_s}"
    end
  end
end