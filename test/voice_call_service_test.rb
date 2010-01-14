#!/usr/bin/env ruby -d

# To be run from the lib folder

require 'test/unit'

require File.dirname(__FILE__) + '/../lib/voice_call_service/voice_call_service'

class VoiceCallServiceTest < Test::Unit::TestCase

  # Loading username/password for Tests from config file. Section: account
  ACCOUNT = YAML.load_file(File.dirname(__FILE__) + "/../config/test_settings.yml")["account"]

  def initialize(method_name)
    @voice_call_service = VoiceCallService::VoiceCallService.new(ACCOUNT["username"], ACCOUNT["password"])
    super(method_name)
  end

  # Initiate new call:
  # Call to +4932-000003 - wait time, call duration 2 seconds, hang up
  # Privacy is disabled for both participants.
  def test_new_call
    voice_call = @voice_call_service.new_call("+4932-000001", "+4932-000003", 1, 2, ServiceEnvironment.MOCK)

    assert_equal("0000", voice_call.error_code, "Error code was not 0000 (success).")
    assert_equal("the request was successful", voice_call.error_message, "Request was not successful.")
  end

  # Initiate new call with an invalid a_number.
  # Faultstring: the A number is invalid
  def test_new_call_with_invalid_a_number
    assert_raises(ServiceException) do
      voice_call = @voice_call_service.new_call("abcd", "+4932-000003", 1, 2, ServiceEnvironment.MOCK)
    end
  end

  # Initiate new call with an invalid b_number.
  # Faultstring: the B number is invalid
  def test_new_call_with_invalid_b_number
    assert_raises(ServiceException) do
      voice_call = @voice_call_service.new_call("+4932-000003", "abcd", 1, 2, ServiceEnvironment.MOCK)
    end
  end

  # Initiate new call:
  # Call to +4932-000003 - wait time, call duration 2 seconds, hang up
  # Privacy is disabled for both participants.  
  def test_new_call_a_doesn_pick_up
    voice_call = @voice_call_service.new_call("+4932-000004", "+4932-000004", 10, 10, ServiceEnvironment.MOCK)

    assert_equal("0000", voice_call.error_code, "Error code was not 0000 (success).")
    assert_equal("the request was successful", voice_call.error_message, "Request was not successful.")
  end

  # Initiate new call with:
  # Call to +4932-000003 - wait time, call duration 2 seconds, hang up
  # Privacy is enabled for both participants.
  def test_new_call_with_privacy_false
    voice_call = @voice_call_service.new_call("+4932-000001", "+4932-000003", 1, 2, ServiceEnvironment.MOCK, true, true)

    assert_equal("0000", voice_call.error_code, "Error code was not 0000 (success).")
    assert_equal("the request was successful", voice_call.error_message, "Request was not successful.")
  end

  # Test new sequenced call:
  # Call to +4932-000003 and +4932-000002 - wait time, call duration 2 seconds, hang up
  def test_new_call_sequenced

    voice_call = @voice_call_service.new_call_sequenced("+4932-000001", ["+4932-000003", "+4932-000002"], 1, 2)

    assert_equal("0000", voice_call.error_code, "Error code was not 0000 (success).")
    assert_equal("the request was successful", voice_call.error_message, "Request was not successful.")
  end

  # Test new sequenced call with an invalid a number
  # Faultstring: the A number is invalid
  def test_new_call_sequenced_with_invalid_a_number
    assert_raises(ServiceException) do
      voice_call = @voice_call_service.new_call_sequenced("abc", ["+4932-000003", "+4932-000002"], 1, 2)
    end
  end

  # Test new sequenced call with an invalid a number
  # Faultstring: the A number is invalid
    def test_new_call_sequenced_with_invalid_b_number
    assert_raises(ServiceException) do
      voice_call = @voice_call_service.new_call_sequenced("+4932-000003", ["abc", "+4932-000002"], 1, 2)
    end
  end

  # Create a call then retrieve the call's status.
  # This cannot be tested in the mock environment since the sessionID returned by new_call would cause
  # a sessionID invalid error on call_status.
  # Therefore the tests are executed in the sandbox. Due to the 10 call quota in the sandbox this
  # test might fail after executing the test suite several times.  
  def test_call_status
    voice_call_session = @voice_call_service.new_call("+4932-000001", "+4932-000002", 2, 2, ServiceEnvironment.SANDBOX)
    session_id = voice_call_session.session_id
    voice_call = @voice_call_service.call_status(session_id, ServiceEnvironment.SANDBOX, keep_alive = 1)

    assert_equal("0000", voice_call.error_code, "Error code was not 0000 (success).")
    assert_equal("the request was successful", voice_call.error_message, "Request was not successful.")
  end

  # Invoke call status with an invalid session id
  # Faulstring: the Session ID is invalid
  def test_call_status_with_invalid_session_id
    assert_raises(ServiceException) do
      voice_call = @voice_call_service.call_status(999999, ServiceEnvironment.SANDBOX, keep_alive = 1)
    end
  end

  # Initiates a call and cancels it by calling teardown_call.
  # This test might fail on unsufficient sandbox quota (see README for details).
  def test_teardown_call
    voice_call_session = @voice_call_service.new_call("+4932-000001", "+4932-000002", 2, 2, ServiceEnvironment.SANDBOX)

    session_id = voice_call_session.session_id
    teardown_response = @voice_call_service.teardown_call(session_id, ServiceEnvironment.SANDBOX)

    assert_equal("0000", teardown_response.error_code, "Error code was not 0000 (success).")
    assert_equal("the request was successful", teardown_response.error_message, "Request was not successful.")
  end

  # Initiates a call and cancels it by calling teardown_call with an invalid session id.
  # Faultstring: the Session ID is invalid
  def test_teardown_call_with_invalid_session_id
    voice_call_session = @voice_call_service.new_call("+4932-000001", "+4932-000002", 2, 2, ServiceEnvironment.SANDBOX)

    assert_raises(ServiceException) do
      teardown_response = @voice_call_service.teardown_call(99999, ServiceEnvironment.SANDBOX)
    end
  end
end