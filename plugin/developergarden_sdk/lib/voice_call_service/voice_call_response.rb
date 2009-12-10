require File.dirname(__FILE__) + '/../basic_response'

# Represents a response for a voice call operation, such as <tt>new_call</tt> ot the
# VoiceCallService.
class VoiceCallResponse < BasicResponse

  attr_accessor :session_id

  # Constructor.
  # ===Parameters
  # <tt>response_xml</tt>:: Xml as returned by a <tt>call_status</tt>-method call.
  # <tt>raise_exception_on_error</tt>:: Xml as returned by a <tt>call_status</tt>-method call.
  def initialize(response_xml, raise_exception_on_error = true)
    doc = response_xml.document

    @error_code      = doc.xpath("//status").text
    @error_message   = doc.xpath("//err_msg").text
    @session_id      = doc.xpath("//sessionId").text
    
    raise_on_error(response_xml) if raise_exception_on_error
  end
end