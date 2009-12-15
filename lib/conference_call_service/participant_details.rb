module ConferenceCallService
  class ParticipantDetails
    attr_accessor :first_name, :last_name, :number, :email , :flags

    # Constructor
    def initialize(first_name, last_name, number, email , flags)
      @first_name  = first_name
      @last_name   = last_name
      @number     = number
      @email      = email
      @flags      = flags
    end

    def to_s
      "#{@first_name.to_s} #{@last_name.to_s}, #{@number.to_s}, #{@email.to_s}, #{@flags.to_s}. "
    end
  end
end