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
  end

  def test_create_conference
    conf_details = ConferenceCallService::ConferenceDetails.new("A very important conf", "A very impressive descrption", 30)
    schedule = ConferenceCallService::ConferenceSchedule.new
    response = @service.create_conference("max.mustermann", conf_details, schedule)
    assert_instance_of(ConferenceCallService::CreateConferenceResponse, response)
    assert_equal("0000", response.error_code)
    assert_not_nil(response.conference_id) 
  end

  def test_commit_conference
    conf_id = "1234567890"
    response = @service.commit_conference(conf_id)
    assert_equal("0000", response.error_code)
    assert_instance_of(BasicResponse, response)
  end

  def test_get_conference_status
    
  end
end