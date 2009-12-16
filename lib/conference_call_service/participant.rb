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
      "Participant - id:#{@id.to_s} details:#{@details.to_s}, status:#{@status.to_s}"
    end

    #### Static methods

    def self.build_from_xml(xml_doc)
      id = ConferenceCallService.xpath_query(xml_doc, "participantId").to_s
      details = ParticipantDetails.build_from_xml( ConferenceCallService.xpath_query(xml_doc, "detail") )
      status = { :muted => ConferenceCallService.xpath_query(xml_doc, "status/value").to_s }

      new(id, details, status)
    end
  end
end