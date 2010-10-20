require File.dirname(__FILE__) + '/../authenticated_service'
require File.dirname(__FILE__) + '/../sms_service/sms_validation_response'
require File.dirname(__FILE__) + '/../sms_service/sms_get_validated_numbers_response'

Handsoap.http_driver = :httpclient

# Print http and soap requests and reponses if ruby has been started with -d option.
Handsoap::Service.logger = $stdout if $DEBUG

module SmsService

  # SmsValidationService allows you to use physical mobile phone numbers as the sender number
  # of a text message.
  #
  # See also:
  # * https://www.developergarden.com/openapi/dokumentation/services#4.2.3.
  class SmsValidationService < AuthenticatedService

    @@SMS_VALIDATION_SERVICE_SCHEMA = "http://webservice.sms.odg.tonline.de"

    @@SMS_SERVICE_ENDPOINT = {
            :uri => "https://gateway.developer.telekom.com/p3gw-mod-odg-sms-validation/services/SmsValidationUserService",
            :version => 1
    }

    endpoint @@SMS_SERVICE_ENDPOINT

    # Add namespaces to the handsoap XmlMason document.
    def on_create_document(doc)
      super(doc)
      doc.alias 'smsvs', @@SMS_VALIDATION_SERVICE_SCHEMA
    end

    # Send a validation text message.
    # 
    # Note this method does not support a sandbox service environment.
    # Validated numbers can be used in both the production and sandbox environment.
    # For more details please refer to the developergarden docs.
    # ===Parameters
    # <tt>message</tt>:: Message which should be send along the validation key. Message needs to contain two
    #                    placeholders: #key# and #validUntil#.
    # <tt>number</tt>:: Number to be validated.
    # <tt>originator</tt>:: Originator to be displayed in the receiver's validation text message.
    # <tt>account</tt>:: Optional developergarden subaccount.
    def send_validation_keyword(message, number, originator, environment = ServiceEnvironment.MOCK, account = "")
      response = invoke_authenticated('smsvs:sendValidationKeywordRequest') do |request, doc|
        request.add('message', message)
        request.add('number', number)
        request.add('originator', originator)        
        request.add('account', account)
        request.add('environment', environment)
      end

      return SmsSendValidationResponse.new(response)
    end


    # Validate the requested number using the received keyword.
    # ===Parameters
    # <tt>keyword</tt>:: Secret keyword used to finalize the ongoing validation process. 
    # <tt>number</tt>:: Number to be validated         
    # <tt>environment</tt>:: Note that only the MOCK and PRODUCTION environments can be used. Numbers already validated
    #   in the PRODUCTIOn environment can also be used for sending text messages in the SANDBOX ENVIRONMENT.
    #   Validations with the keyword <tt>SECRET</tt> in the MOCK environment should always succeed.
    def validate(keyword, number, environment = ServiceEnvironment.MOCK)
      response = invoke_authenticated('smsvs:validateRequest') do |request, doc|
        request.add('keyword', keyword)
        request.add('number', number)              
        request.add('environment', environment)
      end

      return SmsSendValidationResponse.new(response)
    end
    
    # Invalidate the given number.
    # ===Parameters
    # <tt>number</tt>:: Number to be invalidated         
    # <tt>environment</tt>:: Note that only the MOCK and PRODUCTION environments can be used. Numbers already validated
    #   in the PRODUCTIOn environment can also be used for sending text messages in the SANDBOX ENVIRONMENT.
    #   Validations with the keyword <tt>SECRET</tt> in the MOCK environment should always succeed.
    def invalidate(number, environment = ServiceEnvironment.MOCK)
      response = invoke_authenticated('smsvs:invalidateRequest') do |request, doc|
        request.add('number', number)              
        request.add('environment', environment)
      end

      return SmsSendValidationResponse.new(response)
    end

    # Retrieves a list of already validated numbers.
    # ===Parameters     
    # <tt>environment</tt>:: Note that only the MOCK and PRODUCTION environments can be used.    
    def get_validated_numbers(environment = ServiceEnvironment.MOCK)
      response = invoke_authenticated('smsvs:getValidatedNumbersRequest') do |request, doc|                
        request.add('environment', environment)
      end

      return SmsGetValidatedNumbersResponse.new(response)
    end
  end
end