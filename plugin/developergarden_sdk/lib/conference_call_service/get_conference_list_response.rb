require File.dirname(__FILE__) + '/../basic_response'

module ConferenceCallService
  class GetConferenceListResponse < BasicResponse

    attr_accessor :conference_ids

    # Constructor.
    # ===Parameters
    # <tt>response_xml</tt>:: Xml as returned by the corresponding method call.
    # <tt>raise_exception_on_error</tt>:: Raise an exception if an error occurs or not?
    def initialize(response_xml, raise_exception_on_error = true)

      @conference_ids = []
      doc = response_xml.document

      @error_code = ConferenceCallService.xpath_query(doc, "statusCode").to_s
      @error_message = ConferenceCallService.xpath_query(doc, "statusMessage").to_s

      ConferenceCallService.xpath_query(doc, "conferenceIds").each do |conference_id_xml|
        @conference_ids << conference_id_xml.to_s        
      end

      raise_on_error(response_xml) if raise_exception_on_error
    end

    def to_s
      ret = "#{@error_code.to_s}: #{@error_message.to_s}\n"
      ret += "Conference ids:\n"
      @conference_ids.each do |conference_id|
        ret += "\t#{conference_id.to_s}\n"
      end
      ret
    end
  end
end