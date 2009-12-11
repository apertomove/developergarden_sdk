require File.dirname(__FILE__) + '/../authenticated_service'
require File.dirname(__FILE__) + '/../ip_location_service/ip_address'
require File.dirname(__FILE__) + '/../ip_location_service/ip_location_response'
require File.dirname(__FILE__) + '/../ip_location_service/ip_address_location'
require File.dirname(__FILE__) + '/../ip_location_service/region'

Handsoap.http_driver = :httpclient

# Print http and soap requests and reponses if ruby has been started with -d option.
Handsoap::Service.logger = $stdout if $DEBUG

module IpLocationService

  # Client to access the developer garden ip location service.
  #
  # See also:
  # * https://www.developergarden.com/openapi/iplocation
  # * http://www.developergarden.com/static/docu/de/ch04s02s06.html
  class IpLocationService < AuthenticatedService

    @@IP_LOCATION_SCHEMA = 'http://iplocation.developer.telekom.com/schema/'

    @@IP_LOCATION_SERVICE_ENDPOINT = {
            :uri => "https://gateway.developer.telekom.com/p3gw-mod-odg-iplocation/services/IPLocation",
            :version => 1
    }

    endpoint @@IP_LOCATION_SERVICE_ENDPOINT

    # Retrieves spatial information about the given ip address.
    # ===Parameters
    # <tt>ip_address</tt>:: IpAddress-object or array of IpAddress-objects for which to perform an ip location. Can be a single ip address or an array.
    #                       of ip addresses.
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.
    # <tt>account</tt>:: IP address for which to perform an ip location.
    def locate_ip(ip_addresses, environment = ServiceEnvironment.MOCK, account = nil)
      ip_location_response = nil
      
      response = invoke_authenticated("locateIP") do |request, doc|
        request.add('environment', environment)

        # If only a single ip has been passed create an array from it to have a more uniform processing afterwards.
        ip_addresses = [ip_addresses] unless ip_addresses.is_a?(Array)

        ip_addresses.each do |ip_address|

          # If there are string ips convert them to IpAddress objects.
          ip_address = IpAddress.new(ip_address) if ip_address.is_a?(String) 

          request.add('address') do |address|
            address.add('ipType', ip_address.ip_type)
            address.add('ipAddress', ip_address.ip_address)
          end
        end
        request.add('account', account) if (account && !account.empty?)
      end

      ip_location_response = IpLocationResponse.new(response)
      
      return ip_location_response
    end

    #### Static Methods

    def self.IP_LOCATON_SCHEMA
      return @@IP_LOCATON_SCHEMA
    end
    

    # Performs a xpath query in the ip location namespace for the given document and query string.
    # === Parameters
    # <tt>doc</tt>:: XmlQueryFront document.
    # <tt>query_string</tt>:: Element to look for
    # <tt>global_search</tt>:: Searches within all levels using "//" if <tt>global_search = true</tt>.    
    def self.xpath_query(doc, query_string, global_search = true)
      xpath_query = ""
      xpath_query = "//" if global_search
      xpath_query += "schema:#{query_string}"

      # Only search if there's at least one element
      doc.xpath(xpath_query, "schema" => @@IP_LOCATION_SCHEMA)
    end
  end
end