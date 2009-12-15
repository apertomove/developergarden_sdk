require File.dirname(__FILE__) + '/../basic_response'

module ConferenceCallService
  class GetRunningConferenceResponse < BasicResponse
    attr_accessor :conference_id

    # Constructor.
    # ===Parameters
    # <tt>response_xml</tt>:: Xml as returned by the corresponding method call.
    # <tt>raise_exception_on_error</tt>:: Raise an exception if an error occurs or not?
    def initialize(response_xml, raise_exception_on_error = true)

      @conference_ids = []
      doc = response_xml.document

      @error_code      = ConferenceCallService.xpath_query(doc, "statusCode").to_s
      @error_message   = ConferenceCallService.xpath_query(doc, "statusMessage").to_s
      @conference_id   = ConferenceCallService.xpath_query(doc, "conferenceId").to_s

      raise_on_error(response_xml) if raise_exception_on_error

    end
    
  end
end