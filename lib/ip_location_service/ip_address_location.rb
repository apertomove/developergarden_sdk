module IpLocationService
  class IpAddressLocation

    attr_accessor :address, :ip_type, :is_in_region, :is_in_city, :is_in_geo, :radius

    def to_s
      "IP: #{@adress}, IP-Type: #{@ip_type}, Region: #{@is_in_region.to_s}, City: #{@is_in_city}, Geo: #{@is_in_geo}, Radius: #{@radius}"
    end

    #### Static methods

    # Builds an IpAddressLocation object from a given
    # xml document.
    # === Parameter
    # <tt>xml_doc</tt>:: XmlQueryFront object as received from a prior query of handsoap's service response.
    def self.build_from_xml(xml_doc)
      ipa = IpAddressLocation.new
      
      if xml_doc then
        ipa.address       = IpLocationService.xpath_query(xml_doc, "ipAddress").to_s
        ipa.ip_type       = IpLocationService.xpath_query(xml_doc, "ipType").to_s
        ipa.radius        = IpLocationService.xpath_query(xml_doc, "radius").to_s
        region_xml_doc    = IpLocationService.xpath_query(xml_doc, "isInRegion")        
        ipa.is_in_region  = Region.build_from_xml(region_xml_doc)
      end
      return ipa
    end
  end
end