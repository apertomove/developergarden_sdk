require 'rubygems'
require 'developergarden_sdk'

@ip_location_service = IpLocationService::IpLocationService.new("<USER>@t-online.de", "<PASSWORD>")

ip = IpLocationService::IpAddress.new("93.222.255.58")
response = @ip_location_service.locate_ip(ip, ServiceEnvironment.PRODUCTION)

puts response.ip_address_locations.first.address
puts response.ip_address_locations.first.is_in_region.country_code
puts response.ip_address_locations.first.is_in_region.region_name

# If you except a single ip location (if you have passed a single ip to look up)
# then you can use the following way to access the location
puts response.ip_address_location.address
puts response.ip_address_location.is_in_region.country_code
puts response.ip_address_location.is_in_region.region_name