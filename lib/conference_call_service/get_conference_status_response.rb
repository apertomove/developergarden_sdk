require File.dirname(__FILE__) + '/../basic_response'

module ConferenceCallService
  class GetConferenceStatusResponse < BasicResponse

    attr_accessor :details, :schedule, :participants, :start_time, :acc

    # Constructor.
    # ===Parameters
    # <tt>response_xml</tt>:: Xml as returned by the corresponding method call.
    # <tt>raise_exception_on_error</tt>:: Raise an exception if an error occurs or not?
    def initialize(response_xml, raise_exception_on_error = true)

      @conference_ids = []
      @participants   = []

      doc = response_xml.document

      @error_code     = ConferenceCallService.xpath_query(doc, "statusCode").to_s
      @error_message  = ConferenceCallService.xpath_query(doc, "statusMessage").to_s

      @details        = ConferenceDetails.build_from_xml(ConferenceCallService.xpath_query(doc, "detail"))
      @schedule       = ConferenceSchedule.build_from_xml(ConferenceCallService.xpath_query(doc, "schedule"))

      participants_xml = ConferenceCallService.xpath_query(doc, "participants")
      participants_xml.each do |participant_xml|
        @participants << Participant.build_from_xml(participant_xml)
      end

      #puts "\n\n--------------\n\n"
      #puts participants_xml.to_xml
      #puts participants_xml.size
      #puts "\n\n--------------\n\n"
      # puts participants_xml[0].to_xml
      #puts participants_xml[0].xpath("cs:detail", "cs" => 'http://ccs.developer.telekom.com/schema/').to_xml

      #puts ".."
      #puts ConferenceCallService.xpath_query(participants_xml[0], "detail").to_xml
      #puts "\n\n--------------\n\n"
      #puts participants_xml[1].to_xml

      #@participants   = 

      raise_on_error(response_xml) if raise_exception_on_error
    end

    def to_s
      ret = "#{@error_code}: #{@error_message}\n"
      ret += "\t" + details.to_s + "\n" if details
      ret += "\t" + schedule.to_s + "\n" if schedule
      ret
    end
  end
end