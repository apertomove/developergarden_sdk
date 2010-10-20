require File.join(File.dirname(__FILE__), 'test_helper')

class LocalSearchServiceTest < Test::Unit::TestCase

  # Loading username/password for Tests from config file. Section: account
  ACCOUNT = YAML.load_file(File.dirname(__FILE__) + "/../config/test_settings.yml")["account"]

  def initialize(method_name)
    @debug   = false
    @service = LocalSearchService::LocalSearchService.new(ACCOUNT["username"], ACCOUNT["password"])
    super(method_name)
  end

  def test_local_search
    search_parameter = {
            :what => "music",
            :test => "test"
    }
    response = @service.local_search(search_parameter, ServiceEnvironment.MOCK)

    assert_instance_of(Handsoap::XmlQueryFront::NodeSelection, response.search_result)
    puts response.search_result.to_xml if @debug

    results_where_locs_where = response.search_result.xpath("//RESULTS/WHERE_LOCS/WHERE").first
    lat = results_where_locs_where["LAT"]
    assert_equal("5061739", lat)    
  end
end