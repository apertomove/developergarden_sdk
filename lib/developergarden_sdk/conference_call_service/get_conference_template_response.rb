require File.dirname(__FILE__) + '/../basic_response'

module ConferenceCallService
  class GetConferenceTemplateResponse < BasicResponse
    attr_accessor :details, :participants

    # Constructor.
    # ===Parameters
    # <tt>response_xml</tt>:: Xml as returned by the corresponding method call.
    # <tt>raise_exception_on_error</tt>:: Raise an exception if an error occurs or not?
    def initialize(response_xml, raise_exception_on_error = true)
      @participants = []
      doc = response_xml.document
      @error_code = ConferenceCallService.xpath_query(doc, "statusCode").to_s
      @error_message = ConferenceCallService.xpath_query(doc, "statusMessage").to_s

      participants_xml = ConferenceCallService.xpath_query(doc, "participants")
      if participants_xml then
        participants_xml.each do |participant_xml|
          @participants << ParticipantDetails.build_from_xml(participant_xml)
        end
      end
      @details  = ConferenceDetails.build_from_xml(ConferenceCallService.xpath_query(doc, "detail"))      
      raise_on_error(response_xml) if raise_exception_on_error
    end
  end
end