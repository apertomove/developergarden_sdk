module ConferenceCallService
  class ParticipantDetails
    attr_accessor :firstname, :lastname, :number, :email, :flags

    @@IS_INITIATOR = 1
    @@IS_NOT_INITIATOR = 0

    # Constructor
    def initialize(firstname, lastname, number, email, flags = @@IS_NOT_INITIATOR)
      @firstname = firstname
      @lastname = lastname
      @number = number
      @email = email
      @flags = flags
    end

    def to_s
      "#{@firstname.to_s} #{@lastname.to_s}, #{@number.to_s}, #{@email.to_s}, #{@flags.to_s}. "
    end

    # Adds all participant details to the given xml_doc object.
    # === Parameters
    # <tt>xml_doc</tt>:: An XmlMason object as given by a handsoap method invokation.
    def add_to_handsoap_xml(xml_doc)
      xml_doc.add('firstName', @firstname.to_s)
      xml_doc.add('lastName', @lastname.to_s)
      xml_doc.add('number', @number.to_s)
      xml_doc.add('email', @email.to_s)
      xml_doc.add('flags', @flags.to_s)
    end

    #### Static methods

    def self.IS_INITIATOR
      @@IS_INITIATOR
    end

    def self.IS_NOT_INITIATOR
      @@IS_NOT_INITIATOR
    end

    def self.build_from_xml(xml_doc)

      # Depending on the answer there might be a nil object, a NodeSelection or a NokogiriDriver.
      # For the parsing a NodeSelection and a NokogiriDriver behave similar but in order to prevent further nil errors
      # we have to see whether the elment is really present. For a nodeselection this is done by using .size > 0
      # which won't work for the nokogiri driver. Maybe handsoap will clean this up in future releases.
      if xml_doc && ( (xml_doc.is_a?(Handsoap::XmlQueryFront::NodeSelection) && xml_doc.size > 0) || xml_doc.is_a?(Handsoap::XmlQueryFront::NokogiriDriver ) ) then
        
        firstname  = ConferenceCallService.xpath_query(xml_doc, "firstName").to_s
        lastname   = ConferenceCallService.xpath_query(xml_doc, "lastName").to_s
        number     = ConferenceCallService.xpath_query(xml_doc, "number").to_s
        email      = ConferenceCallService.xpath_query(xml_doc, "email").to_s
        flags      = ConferenceCallService.xpath_query(xml_doc, "flags").to_s
        new(firstname, lastname, number, email , flags)
      end
    end
  end
end