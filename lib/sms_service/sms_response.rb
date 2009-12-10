require File.dirname(__FILE__) + '/../basic_response'

# Representing a response from the <tt>SmsService</tt>.
class SmsResponse < BasicResponse

  # Constructor.
  # ===Parameters
  # <tt>response_xml</tt>:: Xml as returned by a <tt>sms_status</tt>-method call.
  # <tt>raise_exception_on_error</tt>:: Xml as returned by a <tt>sms_status</tt>-method call.
  def initialize(response_xml, raise_exception_on_error = true)
    doc = response_xml.document

    @error_code      = doc.xpath("//status").to_s
    @error_message   = doc.xpath("//description").to_s

    raise_on_error(response_xml) if raise_exception_on_error
  end

end