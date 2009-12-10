require 'test/unit'
require File.dirname(__FILE__) + '/../lib/sms_service/sms_service'
require File.dirname(__FILE__) + '/../lib/service_environment'

class TestSendSmsService < Test::Unit::TestCase

  # Loading username/password for Tests from config file. Section: account
  ACCOUNT           = YAML.load_file(File.dirname(__FILE__) + "/../config/test_settings.yml")["account"]  
  SUCCESS_MESSAGE   = "Success."

  # Test send sms to a cell phone.
  def test_send_sms

    # Create SmsService instance
    sms = SmsService::SmsService.new(ACCOUNT["username"], ACCOUNT["password"])

    # send sms to cell phone (ENVIRONMENT = 2)
    sms_response = sms.send_sms("+4932-000001", "Send from ruby telekom sdk", "RubySDK", ServiceEnvironment.SANDBOX, "")

    assert_equal("0000", sms_response.error_code, "Error code was not 0000 (success).")
    assert_equal(SUCCESS_MESSAGE, sms_response.error_message, "Request was not successful.")
  end

  # Test send flash sms to a cell phone.
  def test_send_flash_sms
    sms = SmsService::SmsService.new(ACCOUNT["username"], ACCOUNT["password"])

    # send sms to cell phone (ENVIRONMENT = 2)
    sms_response = sms.send_flash_sms("+4932-000001", "Send from ruby handsoap sdk", "RubySDK", ServiceEnvironment.SANDBOX, "")

    assert_equal("0000", sms_response.error_code, "Error code was not 0000 (success).")
    assert_equal(SUCCESS_MESSAGE, sms_response.error_message, "Request was not successful.")
  end


  # Tests whether a service exception is thrown if a bad originator string is given.
  def test_service_exception_for_send_sms_with_bad_originator

    # Create SmsService instance
    sms = SmsService::SmsService.new(ACCOUNT["username"], ACCOUNT["password"])

    # Should throw an error since the originator string is too long.
    sms_response = sms.send_sms("+4932-000001", "Send from ruby telekom sdk", "OriginatorIsToooooooLong", ServiceEnvironment.SANDBOX, "")

    assert_equal("0000", sms_response.error_code, "Error code was not 0000 (success).")
    assert_equal(SUCCESS_MESSAGE, sms_response.error_message, "Request was not successful.")
  end

  # Test send sms to a phone but pass a originator with oversize (>11 characters).
  def test_response_for_send_sms_with_bad_originator

    # Create SmsService instance
    sms = SmsService::SmsService.new(ACCOUNT["username"], ACCOUNT["password"])

    # Should throw an error since the originator string is too long.
    sms_response = sms.send_sms("+4932-000001", "Send from ruby telekom sdk", "OriginatorIsToooooooLong", ServiceEnvironment.SANDBOX, "")

    assert_equal("0000", sms_response.error_code, "Error code was not 0000 (success).")
    assert_equal(SUCCESS_MESSAGE, sms_response.error_message, "Request was not successful.")
  end

  # Test send sms to a phone with some german umlauts.
  def test_send_sms_with_special_chars

    # Create SmsService instance
    sms = SmsService::SmsService.new(ACCOUNT["username"], ACCOUNT["password"])

    sms_response = sms.send_sms("+4932-000001", "Ein Schloß Österreich ähnelt einem Schloß Überherrn.", "RubySDK", ServiceEnvironment.SANDBOX, "")

    assert_equal("0000", sms_response.error_code, "Error code was not 0000 (success).")
    assert_equal(SUCCESS_MESSAGE, sms_response.error_message, "Request was not successful.")
  end

  # Tests whether a service exception is thrown if a bad originator string is given.
  def test_service_exception_for_send_flash_sms_with_bad_originator

    # Create SmsService instance
    sms = SmsService::SmsService.new(ACCOUNT["username"], ACCOUNT["password"])

    # Should throw an error since the originator string is too long.
    sms_response = sms.send_flash_sms("+4932-000001", "Send from ruby telekom sdk", "OriginatorIsToooooooooooLong", ServiceEnvironment.SANDBOX, "")

    assert_equal("0000", sms_response.error_code, "Error code was not 0000 (success).")
    assert_equal(SUCCESS_MESSAGE, sms_response.error_message, "Request was not successful.")
  end

  # Test send sms to a phone but pass a originator with oversize (>11 characters).
  # This test also succeeds if no exception is thrown.
  # Whether an exception is thrown is covered by another test.
  def test_response_for_send_flash_sms_with_bad_originator

    # Create SmsService instance
    sms = SmsService::SmsService.new(ACCOUNT["username"], ACCOUNT["password"])

    begin
      
      # Should throw an error since the originator string is too long.
      sms_response = sms.send_flash_sms("+4932-000001", "Send from ruby telekom sdk", "OriginatorIsTooooooooooooLong", ServiceEnvironment.SANDBOX, "")
    rescue ServiceException => se
      r = se.response

      assert_equal("0005", r.error_code, "Error code was not \"0005\" (the name of the sender is invalid).")
      assert_equal("the name of the sender is invalid", r.error_message, "It was exepected to receive: the name of the sender is invalid.")
    end

  end

  # Test send sms to a phone with some german umlauts.
  def test_send_flash_sms_with_special_chars

    # Create SmsService instance
    sms = SmsService::SmsService.new(ACCOUNT["username"], ACCOUNT["password"])

    sms_response = sms.send_flash_sms("+4932-000001", "Ein Schloß Österreich ähnelt einem Schloß Überherrn.", "RubySDK", ServiceEnvironment.SANDBOX, "")

    assert_equal("0000", sms_response.error_code, "Error code was not 0000 (success).")
    assert_equal(SUCCESS_MESSAGE, sms_response.error_message, "Request was not successful.")
  end
end