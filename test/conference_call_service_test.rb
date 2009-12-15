#!/usr/bin/env ruby

# To be run from the lib folder

require 'test/unit'


require File.dirname(__FILE__) + '/../lib/conference_call_service/conference_call_service'

class ConferenceCallServiceTest < Test::Unit::TestCase

  # Loading username/password for Tests from config file. Section: account
  ACCOUNT = YAML.load_file(File.dirname(__FILE__) + "/../config/test_settings.yml")["account"]

  def initialize(method_name)
    @service = ConferenceCallService::ConferenceCallService.new(ACCOUNT["username"], ACCOUNT["password"])
    super(method_name)
  end


  def test_get_conference_list
    response = @service.get_conference_list("max.mustermann", ConferenceCallService::ConferenceConstants.STATUS_ALL, ServiceEnvironment.SANDBOX)

    assert_instance_of(ConferenceCallService::GetConferenceListResponse, response)

    assert_equal("0000", response.error_code)
    puts response
  end

  def test_create_conference
    
  end

end