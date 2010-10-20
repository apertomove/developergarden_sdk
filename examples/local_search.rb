require 'rubygems'
require 'developergarden_sdk'

@service = LocalSearchService::LocalSearchService.new("<USER>@t-online.de", "<PASSWORD>")

search_parameter = {
  :what => "music",
  :near => "Konstanz"
}
response = @service.local_search(search_parameter, ServiceEnvironment.PRODUCTION)

# Show response xml
puts response.search_result.to_xml
results_where_locs_where = response.search_result.xpath("//RESULTS/WHERE_LOCS/WHERE").first
lat = results_where_locs_where["LAT"]
puts lat