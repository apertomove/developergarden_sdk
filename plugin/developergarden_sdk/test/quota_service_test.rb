#!/usr/bin/env ruby

require 'test/unit'

require File.dirname(__FILE__) + '/../lib/quota_service/quota_service'

class QuotaServiceTest < Test::Unit::TestCase

  # Loading username/password for Tests from config file. Section: account
  ACCOUNT = YAML.load_file(File.dirname(__FILE__) + "/../config/test_settings.yml")["account"]

  def initialize(test_method_name)
    @q = QuotaService::QuotaService.new(ACCOUNT["username"], ACCOUNT["password"])
    super(test_method_name)
  end

  # Verify whether the quota information response has been well assembled. 
  def test_get_quota_information

    qi = @q.get_quota_information("VoiceButlerSandbox")

    assert_equal("0000", qi.error_code, "Error code was not 0000 (success).")
    assert_equal("the request was successful", qi.error_message, "Request was not successful.")
    assert_not_nil(qi.max_quota)
    assert_not_nil(qi.max_user_quota)
    assert_not_nil(qi.quota_level)
  end

  # Test changing the max user quota.
  # Tests need to be performed in the sandbox.
  # The original quota value as it was before the test will be restored afterwards.
  def test_change_quota_pool

    # back up the original max quota value
    qi = @q.get_quota_information("VoiceButlerSandbox")
    original_max_user_quota = qi.max_user_quota

    # Now change the value
    r = @q.change_quota_pool("VoiceButlerSandbox", 5)

    # Check whether this has been successful
    qi = @q.get_quota_information("VoiceButlerSandbox")
    assert_equal(5, qi.max_user_quota)

    # Restore original value
    r = @q.change_quota_pool("VoiceButlerSandbox", original_max_user_quota)
  end

  # Test to change the max user quota beyond allowed boundaries (colliding with sandbox
  # restrictions). 
  def test_failing_change_quota_pool
    
    # Try to change the value. This won't modify anything since it fails for sure.
    assert_raise( ServiceException ) do
      @q.change_quota_pool("VoiceButlerSandbox", 50000)
    end    
  end

  # Test whether the response object is included in the service exception object.
  def test_failing_change_quota_pool_service_exception
    begin
      @q.change_quota_pool("VoiceButlerSandbox", 50000)
    rescue ServiceException => se
      r = se.response

      # We expect an 0060 response here
      assert_equal("0060", r.error_code)
    end
  end

  # Test failure on missing arguments.
  # This will cause an internal error on the remote server:
  # Faultmessage: an internal error occurred
  def test_change_quota_pool_missing_arguments

    # Try to change the value. This won't modify anything since it fails for sure.
    assert_raise( ServiceException ) do
      @q.change_quota_pool(nil, nil)
    end
  end

  # Test failure on missing quota argument.
  # This will cause an internal error on the remote server:
  # Faultmessage: an internal error occurred
  def test_change_quota_pool_missing_quota_argument

    # Try to change the value. This won't modify anything since it fails for sure.
    assert_raise( ServiceException ) do
      @q.change_quota_pool("VoiceButlerSandbox", nil)
    end
  end

  # Test failure on missing module argument.
  # This will cause an error on the remote server:
  # Faultmessage: the selected module id is unknown.
  def test_change_quota_pool_missing_module_argument

    # Try to change the value. This won't modify anything since it fails for sure.
    assert_raise( ServiceException ) do
      @q.change_quota_pool(nil, 5)
    end
  end

  # Test failure on unexpected module argument.
  # This will cause an error on the remote server:
  # Faultmessage: the selected module id is unknown.
  def test_change_quota_pool_unexpected_module_argument

    # Try to change the value. This won't modify anything since it fails for sure.
    assert_raise( ServiceException ) do
      @q.change_quota_pool(nil, 5)
    end
  end
end