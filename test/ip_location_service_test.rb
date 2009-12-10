#!/usr/bin/env ruby

# To be run from the lib folder

require 'test/unit'


require File.dirname(__FILE__) + '/../lib/ip_location_service/ip_location_service'

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
    region_xml = open(File.dirname(__FILE__) + "/fixtures/ip_location_service/is_in_region.xml")
    region_xml_doc = Handsoap::XmlQueryFront.parse_string(region_xml, :nokogiri)
    
    assert_nothing_raised do
      region = IpLocationService::Region.build_from_xml(region_xml_doc)
    end  
  end

  def test_build_region_witht_valid_attributes
    region_xml = open(File.dirname(__FILE__) + "/fixtures/ip_location_service/is_in_region.xml")
    region_xml_doc = Handsoap::XmlQueryFront.parse_string(region_xml, :nokogiri)      
    region = IpLocationService::Region.build_from_xml(region_xml_doc)

    assert_equal("de", region.country_code)
    assert_equal("Lokalhost",region.region_name)
  end


  def test_build_ip_address_location_without_exception
    ip_address_location_xml = open(File.dirname(__FILE__) + "/fixtures/ip_location_service/ip_address_location.xml")
    ip_address_location_xml_doc = Handsoap::XmlQueryFront.parse_string(ip_address_location_xml, :nokogiri)
    
    assert_nothing_raised do
      ip_location_response = IpLocationService::IpAddressLocation.build_from_xml(ip_address_location_xml_doc)
    end     
  end

  # Hier wird getestet, ob auch die Attribute korrekt gesetzt wurden.
  def test_build_ip_address_location_without_valid_attributes
    ip_address_location_xml = open(File.dirname(__FILE__) + "/fixtures/ip_location_service/ip_address_location.xml")
    ip_address_location_xml_doc = Handsoap::XmlQueryFront.parse_string(ip_address_location_xml, :nokogiri)
    ip_location_response = IpLocationService::IpAddressLocation.build_from_xml(ip_address_location_xml_doc)
    assert_equal("de", ip_location_response.is_in_region.country_code)
    assert_equal("Lokalhost", ip_location_response.is_in_region.region_name)
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
    @ip_location_service.locate_ip("127.0.0.1")
  end

  def test_locate_ip_by_ip_string_array
    assert(false, "Unimplemented")
  end

  def test_locate_ip_by_ip_address_object
    ip = IpLocationService::IpAddress.new("127.0.0.1")
    response = @ip_location_service.locate_ip(ip)
    assert_instance_of(IpLocationService::IpLocationResponse, response)
    puts response
  end

  def test_locate_ip_by_ip_address_object_array
    assert(false, "Unimplemented")
  end
end