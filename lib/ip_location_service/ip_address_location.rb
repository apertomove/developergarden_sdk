module IpLocationService
  class IpAddressLocation

    attr_accessor :address, :ip_type, :is_in_region, :is_in_city, :is_in_geo, :radius

    def initialize
      @address      = nil
      @ip_type      = nil
      @is_in_region = nil
      @is_in_city   = nil
      @is_in_geo    = nil
      @radius       = nil
    end

    def to_s
      ret = "IP: #{@address.to_s}, IP-Type: #{@ip_type.to_s}, Region: #{@is_in_region.to_s}, "
      ret += "City: #{@is_in_city.to_s}, Geo: #{@is_in_geo.to_s}, Radius: #{@radius.to_s}"
      ret
    end

    #### Static methods

    # Builds an IpAddressLocation object from a given
    # xml document.
    # === Parameter
    # <tt>xml_doc</tt>:: XmlQueryFront object as received from a prior query of handsoap's service response.
    def self.build_from_xml(xml_doc)
      ipa = IpAddressLocation.new

      if xml_doc then

        # We are passing "false" do search relative to the xml_doc position. Without this flag the resulting
        # xpath query would beginn with a "//" which would always look the search term relative from the beginning
        # of the document. This is not what we want right here. We would rather like to search relative to the
        # partial tree we have with xml_doc pointing to the IpAddressLocation tag of the response xml.
        # This is also true for Region's build method.
        ipa.address       = IpLocationService.xpath_query(xml_doc, "ipAddress", false).to_s        
        ipa.ip_type       = IpLocationService.xpath_query(xml_doc, "ipType", false).to_s
        ipa.radius        = IpLocationService.xpath_query(xml_doc, "radius", false).to_s
        region_xml_doc    = IpLocationService.xpath_query(xml_doc, "isInRegion", false)        
        ipa.is_in_region  = Region.build_from_xml(region_xml_doc)
      end
      return ipa
    end
  end
end