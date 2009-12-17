#!/usr/bin/env ruby

# To be run from the lib folder

require 'test/unit'

require File.dirname(__FILE__) + '/../lib/conference_call_service/conference_call_service'


# Some ot the tests here run against the sandbox while most run against the mock environment.
# The mock environment currently does not allow a complete test coverage so these cases are covered
# using the sandbox. This shouldn't affect your sandbox quota since these methods won't cost anything.
# Be aware when looking for failures and pay attention of not mixing sandbox and mock calls since they won't
# work together because of the inconsistent data in both environments.
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
    for_temporary_conference do |conf_id|
      response = @service.commit_conference(conf_id)
      assert_instance_of(ConferenceCallService::CommitConferenceResponse, response)
      assert_equal("0000", response.error_code)
    end
  end

  def test_get_conference_status

    for_temporary_conference_with_participants do |conference_id, participant_ids|
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

      assert_instance_of(ConferenceCallService::Participant, response.participants[0])
      assert_equal("User", response.participants[0].details.firstname)
    end
  end

  def test_new_participant
    for_temporary_conference do |conference_id|
      participant = ConferenceCallService::ParticipantDetails.new('pete', 'glocke', '+493200000001', 'pete@spin.to', 0)
      response = @service.new_participant(conference_id, participant)

      assert_instance_of(ConferenceCallService::NewParticipantResponse, response)
      assert_equal("0000", response.error_code)
      assert_not_nil(response.participant_id)
    end
  end

  def test_update_participant
    for_temporary_conference_with_participants do |conference_id, participant_ids|
      participant_detail = ConferenceCallService::ParticipantDetails.new('pete', 'glocke', '+493200000001', 'pete@spin.to', 0)
      action   = ConferenceCallService::ConferenceConstants.ACTION_MUTE
      response = @service.update_participant(conference_id, participant_ids.first, participant_detail, action)
      assert_equal("0000", response.error_code)
    end
  end

  def test_remove_participant
    for_temporary_conference do |conference_id|
      participant_id = "abc"
      response = @service.remove_participant(conference_id, participant_id)
      assert_equal("0000", response.error_code)
    end
  end

  def test_get_running_conference
    for_temporary_conference do |conference_id|
      participant_id = "abc"

      response = @service.remove_participant(conference_id, participant_id)
      assert_equal("0000", response.error_code)
    end
  end

  def test_get_conference_template_list
    owner_id = "max.mustermann"
    response = @service.get_conference_template_list(owner_id, ServiceEnvironment.SANDBOX)
    assert_instance_of(ConferenceCallService::GetConferenceTemplateListResponse, response)
    assert_equal("0000", response.error_code)
    assert_not_nil(response.template_ids)    
  end

  def test_create_conference_template
    owner_id = "max.mustermann"
    details = ConferenceCallService::ConferenceDetails.new("A very important conf", "A very impressive description", 30)

    # giving participants to the method is optional
    participants = Array.new
    participants << ConferenceCallService::ParticipantDetails.new('Lucas', 'Pinto', '+493200000001', 'luc@spin.to', 0)
    participants << ConferenceCallService::ParticipantDetails.new('Jonathan', 'Gainsbeurre', '+493200000001', 'kl@kkl.ak', 0)
    response = @service.create_conference_template(owner_id, details, participants)
    #response = @service.create_conference_template(owner_id, details)
    assert_instance_of(ConferenceCallService::CreateConferenceTemplateResponse, response)
    assert_equal("0000", response.error_code)
    assert_not_nil(response.template_id)
  end

  def test_update_conference_template
    for_temporary_template do |template_id|
      initiator_id = "pid1"
      conf_details = ConferenceCallService::ConferenceDetails.new("A very important conf", "A very impressive description", 30)

      response = @service.update_conference_template(template_id, initiator_id, conf_details)
      assert_instance_of(ConferenceCallService::UpdateConferenceTemplateResponse, response)
      assert_equal("0000", response.error_code)
    end
  end

  def test_remove_conference_template
    for_temporary_template do |template_id|
      response = @service.remove_conference_template(template_id)
      assert_equal("0000", response.error_code)
    end
  end

  def test_get_conference_template
    for_temporary_template(ServiceEnvironment.SANDBOX) do |template_id|      
      response = @service.get_conference_template(template_id, ServiceEnvironment.SANDBOX)

      assert_instance_of(ConferenceCallService::GetConferenceTemplateResponse, response)
      assert_equal("0000", response.error_code)
      assert_not_nil(response.participants)
      assert_not_nil(response.participants.first.firstname)
      assert_not_nil(response.participants.first.lastname)
      assert_not_nil(response.participants.first.number)
      assert_not_nil(response.participants.first.email)
      assert_not_nil(response.participants.first.flags)
      assert_not_nil(response.details)
      assert_not_nil(response.details.name)
      assert_not_nil(response.details.description)
      assert_not_nil(response.details.duration)
    end
  end

  def test_get_conference_template_participant
    for_temporary_template_with_participant_id(ServiceEnvironment.SANDBOX) do |template_id, participant_id|

      response = @service.get_conference_template_participant(template_id, participant_id, ServiceEnvironment.SANDBOX)
      assert_instance_of(ConferenceCallService::GetConferenceTemplateParticipantResponse, response)
      assert_equal("0000", response.error_code)
      assert_not_nil(response.participant)
      assert_not_nil(response.participant.firstname)
      assert_not_nil(response.participant.lastname)
      assert_not_nil(response.participant.number)
      assert_not_nil(response.participant.email)
      assert_not_nil(response.participant.flags)
    end
  end

  def test_add_conference_template_participant
    for_temporary_template do |template_id|
      participant = ConferenceCallService::ParticipantDetails.new('John', 'Doe', '+493200000003', 'john@spin.to', 0)

      response = @service.add_conference_template_participant(template_id, participant)
      assert_instance_of(ConferenceCallService::AddConferenceTemplateParticipantResponse, response)
      assert_equal("0000", response.error_code)
      assert_not_nil(response.participant_id)
    end
  end

  def test_update_conference_template_participant
    for_temporary_template do |template_id|
      participant_id = "pid1"
      participant = ConferenceCallService::ParticipantDetails.new('maxi', 'max', '+493200000001', 'max@spin.to', 0)
      
      response = @service.update_conference_template_participant(template_id, participant_id, participant)
      assert_instance_of(ConferenceCallService::UpdateConferenceTemplateParticipantResponse, response)
      assert_equal("0000", response.error_code)
    end
  end

  def test_remove_conference_template_participant
    for_temporary_template do |template_id|
      participant_id = "pid"

      response = @service.remove_conference_template_participant(template_id, participant_id)
      assert_instance_of(ConferenceCallService::RemoveConferenceTemplateParticipantResponse, response)
      assert_equal("0000", response.error_code)
    end
  end

  def test_remove_conference
    conf_id = create_template_with_participant
    response = @service.remove_conference(conf_id)
    assert_instance_of(ConferenceCallService::RemoveConferenceResponse, response)
    assert_equal("0000", response.error_code)
  end

  def test_update_conference
    for_temporary_conference_with_participants do |conf_id, participant_ids|
      conf_details = ConferenceCallService::ConferenceDetails.new('Une Grosse Conference', 'Une petite description', 42)
      schedule = ConferenceCallService::ConferenceSchedule.new
      response = @service.update_conference(conf_id, conf_details, schedule, "my_new_initiator")

      assert_instance_of(ConferenceCallService::UpdateConferenceResponse, response)
      assert_equal("0000", response.error_code)      
    end
  end

  def test_get_participant_status
    for_temporary_conference_with_participants do |conference_id, participant_ids|
      response = @service.get_participant_status(conference_id, participant_ids.first)

      assert_instance_of(ConferenceCallService::GetParticipantStatusResponse, response)
      assert_equal("0000", response.error_code)      
      assert_instance_of(Hash, response.status)
      assert_equal("+493200000001", response.status["number"])
      assert_equal("false", response.status["muted"])
      assert_equal("Joined", response.status["status"])
    end
  end

  protected

  # Creates a conference and returns its conference id.
  def create_conference(environment = ServiceEnvironment.MOCK)
    conf_details = ConferenceCallService::ConferenceDetails.new("A very important conf", "A very impressive description", 30)
    schedule = ConferenceCallService::ConferenceSchedule.new
    response = @service.create_conference("max.mustermann", conf_details, schedule, environment)
    return response.conference_id
  end

  def remove_conference(conference_id, environment = ServiceEnvironment.MOCK)
    conf_id = create_conference
    response = @service.remove_conference(conf_id)
    assert_instance_of(ConferenceCallService::RemoveConferenceResponse, response, environment)
    assert_equal("0000", response.error_code)
  end

  # Creates a conference, executes the given block and deleted the conf afterwards
  def for_temporary_conference(environment = ServiceEnvironment.MOCK, &block)
    conf_id = create_conference(environment)
    yield(conf_id)
    remove_conference(conf_id, environment)
  end

  def for_temporary_conference_with_participants(environment = ServiceEnvironment.MOCK, &block)
    for_temporary_conference(environment) do |conf_id|

      participant_ids = []
      # Add two participants
      participant = ConferenceCallService::ParticipantDetails.new('maxi', 'max', '+493200000001', 'max@spin.to', 0)
      participant2 = ConferenceCallService::ParticipantDetails.new('roger', 'beep', '+493200000002', 'roger@spin.to', 0)
      response = @service.new_participant(conf_id, participant, environment)
      participant_ids << response.participant_id
      response = @service.new_participant(conf_id, participant2, environment)

      participant_ids << response.participant_id
      
      yield(conf_id, participant_ids)
    end
  end 

  # Creates a conference template and returns its conference template id.
  def create_template_with_participant(environment = ServiceEnvironment.MOCK)    
    owner_id = "max.mustermann"
    conf_details = ConferenceCallService::ConferenceDetails.new("A very important conf", "A very impressive description", 30)

    # giving participants to the method is optional
    participants = Array.new
    participants << ConferenceCallService::ParticipantDetails.new('Serge', 'H.', '+493200000001', 'luc@spin.to', 0)
    participants.first.flags = ConferenceCallService::ParticipantDetails.IS_INITIATOR
    participants << ConferenceCallService::ParticipantDetails.new('Jonathan', 'Gainsbeurre', '+493200000002', 'kl@kkl.ak', 0)

    response = @service.create_conference_template(owner_id, conf_details, participants, environment)
    return response.template_id
  end

  def remove_template(template_id, environment = ServiceEnvironment.MOCK)    
    response = @service.remove_conference_template(template_id, environment)
    assert_instance_of(ConferenceCallService::RemoveConferenceTemplateResponse, response)
    assert_equal("0000", response.error_code)
  end
  # Creates a conference template, executes the given block and deleted the conf afterwards
  def for_temporary_template(environment = ServiceEnvironment.MOCK, &block)
    template_id = create_template_with_participant(environment)
    yield(template_id)
    remove_template(template_id, environment)
  end

  def for_temporary_template_with_participant_id(environment = ServiceEnvironment.MOCK, &block)
    template_id = create_template_with_participant(environment)

    participant = ConferenceCallService::ParticipantDetails.new('Peter', 'Ustinow', '+493200000004', 'peter@spin.to', ConferenceCallService::ParticipantDetails.IS_INITIATOR)
    response = @service.add_conference_template_participant(template_id, participant, environment)
    assert_equal("0000", response.error_code) 

    participant_id = response.participant_id 

    yield(template_id, participant_id)
    remove_template(template_id, environment)
  end
end