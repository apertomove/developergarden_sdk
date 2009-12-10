require File.dirname(__FILE__) + '/../basic_response'

module IpLocationService
  class IpLocationResponse < BasicResponse
    attr_accessor :ip_address_location

    # Constructor.
    # ===Parameters
    # <tt>response_xml</tt>:: Xml as returned by a <tt>ip_location</tt>-method call.
    # <tt>raise_exception_on_error</tt>:: Xml as returned by a <tt>call_status</tt>-method call.
    def initialize(response_xml, raise_exception_on_error = true)

      doc = response_xml.document
      @error_code           = IpLocationService.xpath_query(doc, "statusCode").to_s      
      @error_message        = IpLocationService.xpath_query(doc, "statusMessage").to_s

      ip_address_location_doc = IpLocationService.xpath_query(doc, "ipAddressLocation")      

      @id_address_location    = IpAddressLocation.build_from_xml(ip_address_location_doc)

      raise_on_error(response_xml) if raise_exception_on_error
    end

    def to_s
      "Status: #{@error_code}, Message: #{@error_message}, Location: #{@id_address_location}."
    end
    
  end
end