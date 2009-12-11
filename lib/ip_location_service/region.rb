module IpLocationService

  # Represents a region as used within the IpAddressLocation class in the context of the IpLocationService.
  class Region
    attr_accessor :country_code, :region_code, :region_name

    def to_s
      "Region: #{@country_code.to_s}, #{@region_code.to_s}, #{@region_name.to_s}"
    end

    #### Static methods

    def self.build_from_xml(xml_doc)
      region = Region.new

      if xml_doc then
        region.country_code = IpLocationService.xpath_query(xml_doc, "countryCode", false).to_s
        region.region_code  = IpLocationService.xpath_query(xml_doc, "regionCode", false).to_s
        region.region_name  = IpLocationService.xpath_query(xml_doc, "regionName", false).to_s
      end      
      return region
    end
  end
end