require File.dirname(__FILE__) + '/../basic_response'

# Represents a response for a voice call operation, such as <tt>new_call</tt> ot the
# VoiceCallService.
class CallStatusResponse < BasicResponse

  attr_accessor :connection_time_a, :connection_time_b, :description_a, :description_b, :reason_a, :reason_b
  attr_accessor :state_a, :state_b

  # Constructor.
  # ===Parameters
  # <tt>response_xml</tt>:: Xml as returned by a <tt>call_status</tt>-method call.
  # <tt>raise_exception_on_error</tt>:: Xml as returned by a <tt>call_status</tt>-method call.
  def initialize(response_xml, raise_exception_on_error = true)
    doc = response_xml.document

    @error_code      = doc.xpath("//status").text
    @error_message   = doc.xpath("//err_msg").text
    @session_id      = doc.xpath("//sessionId").text
    @connection_time_a = doc.xpath("//connectiontimea").text
    @connection_time_b = doc.xpath("//connectiontimeb").text
    @description_a = doc.xpath("//descriptiona").text
    @description_b = doc.xpath("//descriptionb").text
    @reason_a = doc.xpath("//reasona").text
    @reason_b = doc.xpath("//reasonb").text
    @state_a = doc.xpath("//statea").text
    @state_b = doc.xpath("//stateb").text

    raise_on_error(response_xml) if raise_exception_on_error
  end
end