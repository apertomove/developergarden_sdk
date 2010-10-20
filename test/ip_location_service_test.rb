require File.join(File.dirname(__FILE__), 'test_helper')

class IpLocationServiceTest < Test::Unit::TestCase

  # Loading username/password for Tests from config file. Section: account
  ACCOUNT = YAML.load_file(File.dirname(__FILE__) + "/../config/test_settings.yml")["account"]

  def initialize(method_name)
    @ip_location_service = IpLocationService::IpLocationService.new(ACCOUNT["username"], ACCOUNT["password"])
    super(method_name)
  end


  # See whether we can create an ipv4 address
  def test_ip_address_v4
    ip = IpLocationService::IpAddress.new("127.0.0.1")
    assert_equal("127.0.0.1", ip.ip_address)
    assert_equal(IpLocationService::IpAddress.IP_V4, ip.ip_type)
  end

  # See whether we can create an ipv6 address
  def test_ip_address_v6
    ip = IpLocationService::IpAddress.new("127.0.0.1", IpLocationService::IpAddress.IP_V6)
    assert_equal("127.0.0.1", ip.ip_address)
    assert_equal(IpLocationService::IpAddress.IP_V6, ip.ip_type)
  end

  # See whether we can create an ipv4 address
  def test_ip_address_build_from_ip_address_from_string
    another_ip = IpLocationService::IpAddress.build_from_ip_address("127.0.0.1")
    assert_equal("127.0.0.1", another_ip.ip_address)
    assert_equal(IpLocationService::IpAddress.IP_V4, another_ip.ip_type)
  end

  # See whether we can create an ipv4 address
  def test_ip_address_build_from_ip_address_from_ip_address_object
    ip = IpLocationService::IpAddress.new("127.0.0.1")

    another_ip = IpLocationService::IpAddress.build_from_ip_address(ip)
    assert_equal("127.0.0.1", another_ip.ip_address)
    assert_equal(IpLocationService::IpAddress.IP_V4, another_ip.ip_type)
  end

  def test_build_region_without_exception
    response_xml = open(File.dirname(__FILE__) + "/fixtures/ip_location_service/ip_location_response.xml")
    response_xml_doc = Handsoap::XmlQueryFront.parse_string(response_xml, :nokogiri)
    ip_address_location_doc = IpLocationService::IpLocationService.xpath_query(response_xml_doc, "ipAddressLocation")
    region_xml_doc = IpLocationService::IpLocationService.xpath_query(ip_address_location_doc, "isInRegion", false)

    assert_nothing_raised do
      region = IpLocationService::Region.build_from_xml(region_xml_doc)      
    end
  end


  def test_build_region_with_valid_attributes
    response_xml = open(File.dirname(__FILE__) + "/fixtures/ip_location_service/ip_location_response.xml")
    response_xml_doc = Handsoap::XmlQueryFront.parse_string(response_xml, :nokogiri)
    ip_address_location_doc = IpLocationService::IpLocationService.xpath_query(response_xml_doc, "ipAddressLocation")
    region_xml_doc = IpLocationService::IpLocationService.xpath_query(ip_address_location_doc, "isInRegion", false)
    region = IpLocationService::Region.build_from_xml(region_xml_doc)

    assert_equal("de", region.country_code)
    assert_equal("Lokalhost", region.region_name)
  end


  def test_build_ip_address_location_without_exception
    response_xml = open(File.dirname(__FILE__) + "/fixtures/ip_location_service/ip_location_response.xml")
    response_xml_doc = Handsoap::XmlQueryFront.parse_string(response_xml, :nokogiri)
    ip_address_location_doc = IpLocationService::IpLocationService.xpath_query(response_xml_doc, "ipAddressLocation")

    assert_nothing_raised do
      ip_location_response = IpLocationService::IpAddressLocation.build_from_xml(ip_address_location_doc)
    end
  end

  # Hier wird getestet, ob auch die Attribute korrekt gesetzt wurden.
  def test_build_ip_address_location_with_valid_attributes
    response_xml = open(File.dirname(__FILE__) + "/fixtures/ip_location_service/ip_location_response.xml")
    response_xml_doc = Handsoap::XmlQueryFront.parse_string(response_xml, :nokogiri)
    ip_address_location_doc = IpLocationService::IpLocationService.xpath_query(response_xml_doc, "ipAddressLocation")

    ip_location_response = IpLocationService::IpAddressLocation.build_from_xml(ip_address_location_doc)
    assert_equal("de", ip_location_response.is_in_region.country_code)
    assert_equal("Lokalhost", ip_location_response.is_in_region.region_name)
    assert_equal("127.0.0.1", ip_location_response.address)
  end

  def test_ip_location_response

    ip_location_response_xml = open(File.dirname(__FILE__) + "/fixtures/ip_location_service/ip_location_response.xml")
    ip_location_response_xml_doc = Handsoap::XmlQueryFront.parse_string(ip_location_response_xml, :nokogiri)
    fake_soap_response = Handsoap::SoapResponse.new(ip_location_response_xml_doc, nil)

    assert_nothing_raised do
      ip_location_response = IpLocationService::IpLocationResponse.new(fake_soap_response)
    end
  end

  def test_locate_ip_by_ip_string
    response = @ip_location_service.locate_ip("127.0.0.1")
    assert_instance_of(IpLocationService::IpLocationResponse, response)

    assert_equal("0000", response.error_code)

    assert_instance_of(IpLocationService::IpAddressLocation, response.ip_address_location)
    assert_equal("de", response.ip_address_location.is_in_region.country_code)
  end

  def test_locate_ip_by_ip_string_array
    ips = [ "127.0.0.1", "128.0.0.1" ]

    response = @ip_location_service.locate_ip(ips)
    assert_instance_of(IpLocationService::IpLocationResponse, response)
    assert_equal("0000", response.error_code)

    assert_instance_of(IpLocationService::IpAddressLocation, response.ip_address_locations[0])
    assert_instance_of(IpLocationService::IpAddressLocation, response.ip_address_locations[1])

    assert_equal("de", response.ip_address_locations[0].is_in_region.country_code)
    assert_equal("de", response.ip_address_locations[1].is_in_region.country_code)

    assert_equal("127.0.0.1", response.ip_address_locations[0].address)

  end

  def test_locate_ip_by_ip_address_object
    ip = IpLocationService::IpAddress.new("127.0.0.1")
    response = @ip_location_service.locate_ip(ip)
    assert_instance_of(IpLocationService::IpLocationResponse, response)

    assert_equal("0000", response.error_code)

    assert_instance_of(IpLocationService::IpAddressLocation, response.ip_address_location)
    assert_equal("de", response.ip_address_location.is_in_region.country_code)
    assert_equal("127.0.0.1", response.ip_address_location.address)
  end

  def test_locate_ip_by_ip_address_object_array
    ips = [ IpLocationService::IpAddress.new("127.0.0.1"), IpLocationService::IpAddress.new("128.0.0.1") ]

    response = @ip_location_service.locate_ip(ips)
    assert_instance_of(IpLocationService::IpLocationResponse, response)
    assert_equal("0000", response.error_code)

    assert_instance_of(IpLocationService::IpAddressLocation, response.ip_address_locations[0])
    assert_instance_of(IpLocationService::IpAddressLocation, response.ip_address_locations[1])

    assert_equal("de", response.ip_address_locations[0].is_in_region.country_code)
    assert_equal("de", response.ip_address_locations[1].is_in_region.country_code)

    assert_equal("127.0.0.1", response.ip_address_locations[0].address)
    assert_equal("128.0.0.1", response.ip_address_locations[1].address)
  end

  def test_locate_ip_for_non_tcom_ip
    # This ip is not a valid tcom ip
    ip = IpLocationService::IpAddress.new("134.96.50.208")

    assert_raises(ServiceException) do
      response = @ip_location_service.locate_ip(ip)
    end
  end

#  def test_locate_ip_production
#    #
#    ip = IpLocationService::IpAddress.new("93.222.255.58")
#    response = @ip_location_service.locate_ip(ip, ServiceEnvironment.PRODUCTION)
#
#    #TODO Encoding
#    puts response.ip_address_locations.first.address
#    puts response.ip_address_locations.first.is_in_region.country_code
#    puts response.ip_address_locations.first.is_in_region.region_name
#    Iconv.conv('ISO-8859-1', 'utf-8', response.ip_address_locations.first.is_in_region.region_name)
#    Iconv.conv('utf-8', 'ISO-8859-1', response.ip_address_locations.first.is_in_region.region_name)
#
#
#    puts response.ip_address_location.address
#    puts response.ip_address_location.is_in_region.country_code
#    puts response.ip_address_location.is_in_region.region_name
#  end
end