module ConferenceCallService
  class Participant
    attr_accessor :id, :details, :status 

    # Constructor
    def initialize(id, details, status)
      @id  = id
      @details   = details
      @status     = status

    end

    def to_s
      "#{@id.to_s} #{@details.to_s}, #{@status.to_s}"
    end

    #### Static methods

    def self.build_from_xml(xml_doc)
      details = ParticipantDetails.build_from_xml( ConferenceCallService.xpath_query(xml_doc, "detail") )      
    end
  end
end