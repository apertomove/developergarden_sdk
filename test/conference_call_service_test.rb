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
    response = @service.get_conference_list("max.mustermann", ConferenceCallService::ConferenceConstants.STATUS_ALL, ServiceEnvironment.MOCK)

    assert_instance_of(ConferenceCallService::GetConferenceListResponse, response)
    assert_equal("0000", response.error_code)

    assert( response.conference_ids.size > 0, "There should be at least one conference id." )

    # Comment in to see a list of available conferences

    # puts response

  end

  def test_create_conference
    conf_details = ConferenceCallService::ConferenceDetails.new("A very important conf", "A very impressive description", 30)
    schedule = ConferenceCallService::ConferenceSchedule.new
    response = @service.create_conference("max.mustermann", conf_details, schedule)
    assert_instance_of(ConferenceCallService::CreateConferenceResponse, response)
    assert_equal("0000", response.error_code)
    assert_not_nil(response.conference_id)
  end

  def test_commit_conference
    with_temporary_conference do |conf_id|
      response = @service.commit_conference(conf_id)
      assert_instance_of(ConferenceCallService::CommitConferenceResponse, response)
      assert_equal("0000", response.error_code)
    end
  end

  def test_get_conference_status
    conference_id = "967191"
    response = @service.get_conference_status(conference_id, ConferenceCallService::ConferenceConstants.STATUS_ALL, ServiceEnvironment.MOCK)

    assert_instance_of(ConferenceCallService::GetConferenceStatusResponse, response)
    assert_equal("0000", response.error_code)

    assert_instance_of(ConferenceCallService::ConferenceDetails, response.details)
    assert_not_nil(response.details.name)
    assert_not_nil(response.details.description)
    assert_not_nil(response.details.duration)

    assert_instance_of(ConferenceCallService::ConferenceSchedule, response.schedule)
    assert_not_nil(response.schedule.minute)
    assert_not_nil(response.schedule.hour)
    assert_not_nil(response.schedule.day_of_month)
    assert_not_nil(response.schedule.month)
    assert_not_nil(response.schedule.year)
    assert_not_nil(response.schedule.recurring)
  end

  def test_new_participant
    with_temporary_conference do |conference_id|
      participant = ConferenceCallService::ParticipantDetails.new('lucas', 'pinto', '+493200000001', 'luc@spin.to', 0)
      response = @service.new_participant(conference_id, participant)

      assert_instance_of(ConferenceCallService::NewParticipantResponse, response)
      assert_equal("0000", response.error_code)
      assert_not_nil(response.participant_id)
    end
  end

  def test_get_conference_status
    with_temporary_conference do |conference_id|
      response = @service.get_conference_status(conference_id, ConferenceCallService::ConferenceConstants.STATUS_ALL, ServiceEnvironment.MOCK)

      assert_instance_of(ConferenceCallService::GetConferenceStatusResponse, response)
      assert_equal("0000", response.error_code)

      assert_instance_of(ConferenceCallService::ConferenceDetails, response.details)
      assert_not_nil(response.details.name)
      assert_not_nil(response.details.description)
      assert_not_nil(response.details.duration)

      assert_instance_of(ConferenceCallService::ConferenceSchedule, response.schedule)
      assert_not_nil(response.schedule.minute)
      assert_not_nil(response.schedule.hour)
      assert_not_nil(response.schedule.day_of_month)
      assert_not_nil(response.schedule.month)
      assert_not_nil(response.schedule.year)
      assert_not_nil(response.schedule.recurring)
    end
  end

  def test_new_participant
    with_temporary_conference do |conference_id|
      participant = ConferenceCallService::ParticipantDetails.new('lucas', 'pinto', '+493200000001', 'luc@spin.to', 0)
      response = @service.new_participant(conference_id, participant)

      assert_instance_of(ConferenceCallService::NewParticipantResponse, response)
      assert_equal("0000", response.error_code)
      assert_not_nil(response.participant_id)
    end
  end


  def test_remove_participant
    with_temporary_conference do |conference_id|
      participant_id = "abc"

      response = @service.remove_participant(conference_id, participant_id)
      assert_equal("0000", response.error_code)
    end
  end

  def test_get_running_conference
    with_temporary_conference do |conference_id|
      participant_id = "abc"

      response = @service.remove_participant(conference_id, participant_id)
      assert_equal("0000", response.error_code)
    end
  end

  def test_get_running_conference
    with_temporary_conference do |conf_id|
      response = @service.get_running_conference(conf_id)
      assert_instance_of(ConferenceCallService::GetRunningConferenceResponse, response)
      assert_equal("0000", response.error_code)
    end
  end

  def test_get_conference_template_list
    owner_id = "max.mustermann"
    response = @service.get_conference_template_list(owner_id)
    assert_instance_of(ConferenceCallService::GetConferenceTemplateListResponse, response)
    assert_equal("0000", response.error_code)
    assert_not_nil(response.template_ids)
  end

  def test_create_conference_template
    owner_id = "max.mustermann"

    details = Array.new
    details << ConferenceCallService::ConferenceDetails.new('Une Grosse Conference', 'Une petite description', 42)
    details << ConferenceCallService::ConferenceDetails.new('Une petite Conference', 'Une modeste description', 24)

    # giving participants to the method is optional
    #participants = Array.new
    #participants << ConferenceCallService::ParticipantDetails.new('Lucas', 'Pinto', '+493200000001', 'luc@spin.to', 0)
    #participants << ConferenceCallService::ParticipantDetails.new('Jonathan', 'Gainsbeurre', '+493200000001', 'kl@kkl.ak', 0)

    response = @service.create_conference_template(owner_id, details)#, participants)
    assert_instance_of(ConferenceCallService::CreateConferenceTemplateResponse, response)
    assert_equal("0000", response.error_code)
    assert_not_nil(response.template_id)
  end

  def test_remove_conference
    conf_id = create_conference
    response = @service.remove_conference(conf_id)
    assert_instance_of(ConferenceCallService::RemoveConferenceResponse, response)
    assert_equal("0000", response.error_code)
  end

  protected

  # Creates a conference and returns its conference id.
  def create_conference
    conf_details = ConferenceCallService::ConferenceDetails.new("A very important conf", "A very impressive description", 30)
    schedule = ConferenceCallService::ConferenceSchedule.new
    response = @service.create_conference("max.mustermann", conf_details, schedule)
    return response.conference_id
  end

  def remove_conference(conference_id)
     conf_id = create_conference
     response = @service.remove_conference(conf_id)
     assert_instance_of(ConferenceCallService::RemoveConferenceResponse, response)
     assert_equal("0000", response.error_code)
  end

  # Creates a conference, executes the given block and deleted the conf afterwards
  def with_temporary_conference(&block)
    conf_id = create_conference
    yield(conf_id)
    remove_conference(conf_id)
  end
end