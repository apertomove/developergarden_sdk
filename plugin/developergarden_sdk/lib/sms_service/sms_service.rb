require File.dirname(__FILE__) + '/../authenticated_service'
require File.dirname(__FILE__) + '/../sms_service/sms_response'

Handsoap.http_driver = :httpclient

# Print http and soap requests and reponses if ruby has been started with -d option.
Handsoap::Service.logger = $stdout if $DEBUG

module SmsService

  # Client to the developer garden sms service.
  # Can be used to send sms and flash sms.
  #
  # See also:
  # * https://www.developergarden.com/openapi/dokumentation/services#4.2.3.
  class SmsService < AuthenticatedService

    @@SMS_SERVICE_ENDPOINT = {
            :uri => "https://gateway.developer.telekom.com/p3gw-mod-odg-sms/services/SmsService",
            :version => 1
    }

    endpoint @@SMS_SERVICE_ENDPOINT

    # Send a sms.
    # Detailed information about sending of sms can be found under:
    # * https://www.developergarden.com/openapi/dokumentation/services#4.2.3.
    # ===Parameters
    # <tt>numbers</tt>:: Up to 10 receivers can be specified separated by commas (",").
    # <tt>sms_message</tt>:: Actual message. Can be up to 765 characters. A sms will be charged for each 153 chars.
    # <tt>originator</tt>:: String to be displayed as the originator of the message.
    # Max. 11 characters. Further chars will be cut of. Allowed chars are [a-zA-Z0-9].
    # <tt>environment</tt>:: Service environment as defined in ServiceEnvironment.
    # <tt>account</tt>:: Currently unused
    def send_sms(numbers, sms_message, originator, environment = 2, account = "")
      return send_sms_common("sendSMS", numbers, sms_message, originator, environment, account)
    end

    # Send a flasg sms. A flash sms goes directly to the handy screen.
    # Detailed information about sending of sms can be found under:
    # * https://www.developergarden.com/openapi/dokumentation/services#4.2.3.
    # ===Parameters
    # <tt>numbers</tt>:: Up to 10 receivers can be specified separated by commas (",").
    # <tt>sms_message</tt>:: Actual message. Can be up to 765 characters. A sms will be charged for each 153 chars.
    # <tt>originator</tt>:: String to be displayed as the originator of the message.
    # Max. 11 characters. Further chars will be cut of. Allowed chars are [a-zA-Z0-9].
    # At least one letter needs to be present.
    # <tt>environment</tt>:: Service environment as defined in ServiceEnvironment.
    # <tt>account</tt>:: Currently unused
    def send_flash_sms(numbers, sms_message, originator, environment = 2, account = "")
      return send_sms_common("sendFlashSMS", numbers, sms_message, originator, environment, account)
    end


    protected

    # Methods sendSMS and sendFlashSMS have identical arguments. They only differ in their action name.
    # ===Parameters
    # <tt>numbers</tt>:: Up to 10 receivers can be specified separated by commas (",").
    # <tt>sms_message</tt>:: Actual message. Can be up to 765 characters. A sms will be charged for each 153 chars.
    # <tt>originator</tt>:: String to be displayed as the originator of the message.
    # Max. 11 characters. Further chars will be cut of. Allowed chars are [a-zA-Z0-9].
    # <tt>environment</tt>:: Service environment as defined in ServiceEnvironment.
    # <tt>account</tt>:: Currently unused
    def send_sms_common(action_name, numbers, sms_message, originator, environment = 2, account = "")

      # Cut originator down to 11 characters
      originator = originator[0, 11]

      response = invoke_authenticated(action_name) do |message, doc|
        message.add("request")
        request = message.find("request")
        request.add('environment', environment)
        request.add('number', numbers)
        request.add('message', sms_message)
        request.add('originator', originator)
        request.add('account', account)
      end

      return SmsResponse.new(response)
    end


  end

end