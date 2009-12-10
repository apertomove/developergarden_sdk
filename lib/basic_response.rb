require File.dirname(__FILE__) + '/service_exception'

# Base class for service responses.
class BasicResponse
  attr_accessor :error_code, :error_message

  # Constructor
  def inizialize
  end

  # Constructor.
  # ===Parameters
  # <tt>response_xml</tt>:: Xml as returned by a <tt>status</tt>-method call.
  # <tt>raise_exception_on_error</tt>:: Xml as returned by a <tt>status</tt>-method call.  
  def initialize(response_xml, raise_exception_on_error = true)
    doc = response_xml.document

    @error_code      = doc.xpath("//errorCode").to_s
    @error_message   = doc.xpath("//errorMessage").to_s

    raise_on_error(response_xml) if raise_exception_on_error
  end

  # Returns <tt>self.inspect</tt>. Good for debugging purposes.
  def to_s
    return self.inspect
  end

  # Raises an exception if the response is an error.
  # Since in some response types the error code is not named "errorCode" it is not possible
  # to call this method only in the constructur of this base class.
  # This is sufficient for services using the BaseResponse directly but subclasses of BaseResponse
  # need to call this method at the end of their constructure <tt>initialize</tt>.
  def raise_on_error(response_xml)
    if @error_code && !@error_code.empty? &&  @error_code != "0000" then

      # It is important to create the exception with self.class.new and not only BasicResponse.new
      # This is because this method can be also invoked from a subclass. If a VoiceCallResponse object for example
      # raises an exception you will receive "VoiceCallResponse" from self.class. This is very important because
      # only the VoiceCallResponse knows that in this case the response code is called <tt>status</tt>.
      # This is because there is an inconsistency within the different service responses. 
      raise(ServiceException.new( self.class.new(response_xml, false) ), "The developer garden service you invoked responded with an error: " + @error_message.to_s)
    end
  end
end