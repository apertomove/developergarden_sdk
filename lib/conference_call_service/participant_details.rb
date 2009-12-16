module ConferenceCallService
  class ParticipantDetails
    attr_accessor :firstname, :lastname, :number, :email , :flags

    # Constructor
    def initialize(firstname, lastname, number, email , flags)
      @firstname  = firstname
      @lastname   = lastname
      @number     = number
      @email      = email
      @flags      = flags
    end

    def to_s
      "#{@firstname.to_s} #{@lastname.to_s}, #{@number.to_s}, #{@email.to_s}, #{@flags.to_s}. "
    end

    #### Static methods

    def self.build_from_xml()
      
    end
  end
end