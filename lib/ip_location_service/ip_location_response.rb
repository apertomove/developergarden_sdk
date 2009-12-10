require File.dirname(__FILE__) + '/../basic_response'

module IpLocationService
  class IpLocationResponse < BasicResponse
    attr_accessor :ip_address_locations

    # Constructor.
    # ===Parameters
    # <tt>response_xml</tt>:: Xml as returned by a <tt>ip_location</tt>-method call.
    # <tt>raise_exception_on_error</tt>:: Xml as returned by a <tt>call_status</tt>-method call.
    def initialize(response_xml, raise_exception_on_error = true)

      doc = response_xml.document
      @error_code = IpLocationService.xpath_query(doc, "statusCode").to_s
      @error_message = IpLocationService.xpath_query(doc, "statusMessage").to_s
      @ip_address_locations = []

      ip_address_location_doc = IpLocationService.xpath_query(doc, "ipAddressLocation")

      ip_address_location_doc.each do |ip_address_location|
        @ip_address_locations << IpAddressLocation.build_from_xml(ip_address_location)
      end

      raise_on_error(response_xml) if raise_exception_on_error
    end

    # Alias for accessing the first element of the ip_address_location array.
    def ip_address_location
      @ip_address_locations.first
    end

    # Alias for accessing the first element of the ip_address_location array.
    def ip_address_location=(location)
      @ip_address_locations[0] = location
    end

    def to_s
      ret = "Status: #{@error_code}, Message: #{@error_message}\nLocations:\n"
      @ip_address_locations.each do |ipl|
        ret += "\t#{ipl}\n"
      end
      ret
    end

  end
end