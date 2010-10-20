require File.dirname(__FILE__) + '/../basic_response'

# Representing a response from the <tt>SmsService</tt>.
class SmsGetValidatedNumbersResponse < BasicResponse

  attr_accessor :validated_numbers

  # Constructor.
  # ===Parameters
  # <tt>response_xml</tt>:: Xml as returned by a <tt>sms_status</tt>-method call.
  # <tt>raise_exception_on_error</tt>:: Xml as returned by a <tt>sms_status</tt>-method call.
  def initialize(response_xml, raise_exception_on_error = true)
    doc = response_xml.document

    @error_code      = doc.xpath("//statusCode").to_s
    @error_message   = doc.xpath("//statusMessage").to_s
    @validated_numbers = []

    validated_numbers_xml   = doc.xpath("//validatedNumbers")

    if validated_numbers_xml.is_a?(Handsoap::XmlQueryFront::NodeSelection) then
      validated_numbers_xml.each do |validated_number_xml|
        validated_number = ValidatedNumber.build_from_xml(validated_number_xml)
        validated_numbers << validated_number        
      end
    else
      raise "Unexpected response format."
    end
    
    raise_on_error(response_xml) if raise_exception_on_error
  end
end

class ValidatedNumber
  attr_accessor :number, :validated_until

  def initialize(number, validated_until)
    @number           = number
    @validated_until  = validated_until
  end

  def self.build_from_xml(xml_doc)
    number = xml_doc.xpath("number").to_s
    validated_until = xml_doc.xpath("validUntil").to_s

    return ValidatedNumber.new(number, validated_until)
  end

  def to_s
    self.inspect
  end
end