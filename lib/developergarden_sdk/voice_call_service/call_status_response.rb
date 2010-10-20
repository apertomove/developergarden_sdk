require File.dirname(__FILE__) + '/../basic_response'

# Represents a response for a voice call operation, such as <tt>new_call</tt> ot the
# VoiceCallService.
class CallStatusResponse < BasicResponse

  attr_accessor :connection_time_a, :connection_time_b, :description_a, :description_b, :reason_a, :reason_b
  attr_accessor :state_a, :state_b, :be164, :bindex

  # Constructor.
  # ===Parameters
  # <tt>response_xml</tt>:: Xml as returned by a <tt>call_status</tt>-method call.
  # <tt>raise_exception_on_error</tt>:: Xml as returned by a <tt>call_status</tt>-method call.
  def initialize(response_xml, raise_exception_on_error = true)
    doc = response_xml.document

    @error_code      = doc.xpath("//status").to_s
    @error_message   = doc.xpath("//err_msg").to_s
    @session_id      = doc.xpath("//sessionId").to_s
    @connection_time_a = doc.xpath("//connectiontimea").to_s
    @connection_time_b = doc.xpath("//connectiontimeb").to_s
    @description_a = doc.xpath("//descriptiona").to_s
    @description_b = doc.xpath("//descriptionb").to_s
    @reason_a = doc.xpath("//reasona").to_s
    @reason_b = doc.xpath("//reasonb").to_s
    @state_a = doc.xpath("//statea").to_s
    @state_b = doc.xpath("//stateb").to_s
    @be164 = doc.xpath("//be164").to_s
    @bindex = doc.xpath("//bindex").to_s


    raise_on_error(response_xml) if raise_exception_on_error
  end
end