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

    def self.build_from_xml(xml_doc)
      firstname  = ConferenceCallService.xpath_query(xml_doc, "firstName").to_s
      lastname   = ConferenceCallService.xpath_query(xml_doc, "lastName").to_s
      number     = ConferenceCallService.xpath_query(xml_doc, "number").to_s
      email      = ConferenceCallService.xpath_query(xml_doc, "email").to_s
      flags      = ConferenceCallService.xpath_query(xml_doc, "flags").to_s
      new(firstname, lastname, number, email , flags)
    end
  end
end