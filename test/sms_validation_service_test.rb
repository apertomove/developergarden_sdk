require File.join(File.dirname(__FILE__), 'test_helper')

class TestSendSmsService < Test::Unit::TestCase

  # Loading username/password for Tests from config file. Section: account
  ACCOUNT           = YAML.load_file(File.dirname(__FILE__) + "/../config/test_settings.yml")["account"]  
  SUCCESS_MESSAGE   = "Success."


  def initialize(method_name)
    @debug   = false
    @service = SmsService::SmsValidationService.new(ACCOUNT["username"], ACCOUNT["password"])
    super(method_name)
  end

  def test_send_validation_keyword

    # Create SmsService instance
    message = "Das Keyword zur Validierung Ihrer Rufnummer lautet #key# und g�ltig bix #validUntil#."
    number  = "+49-12345678"
    originator = "McGuyver"

    sms_response = @service.send_validation_keyword(message, number, originator, ServiceEnvironment.MOCK)    

    assert_equal("0000", sms_response.error_code, "Error code was not 0000 (success).")    
  end

  def test_validate

    # This keyword will always be accepted by the mock environment.
    keyword = "SECRET"
    number  = "+49-12345678"
    
    sms_response = @service.validate(keyword, number, ServiceEnvironment.MOCK)

    assert_equal("0000", sms_response.error_code, "Error code was not 0000 (success).")    
  end

  def test_invalidate
    number  = "+49-12345678"

    sms_response = @service.invalidate(number, ServiceEnvironment.MOCK)

    assert_equal("0000", sms_response.error_code, "Error code was not 0000 (success).")    
  end

  def test_get_validated_numbers
    sms_response = @service.get_validated_numbers(ServiceEnvironment.MOCK)

    assert_equal("0000", sms_response.error_code, "Error code was not 0000 (success).")    
    assert_instance_of(Array, sms_response.validated_numbers)
    assert_not_nil(sms_response.validated_numbers.first.number)
    assert_not_nil(sms_response.validated_numbers.first.validated_until)
  end
end