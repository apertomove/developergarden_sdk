require File.dirname(__FILE__) + '/../authenticated_service'
require File.dirname(__FILE__) + '/../service_environment'
require File.dirname(__FILE__) + '/../voice_call_service/voice_call_response'
require File.dirname(__FILE__) + '/../voice_call_service/call_status_response'

Handsoap.http_driver = :httpclient

# Print http and soap requests and reponses if ruby has been started with -d option.
Handsoap::Service.logger = $stdout if $DEBUG

module VoiceCallService

  # Establish voice calls between two participants
  # See also: http://www.developergarden.com/openapi/dokumentation/services#4.2.1.
  class VoiceCallService < AuthenticatedService
    @@VOICE_CALL_SERVICE_ENDPOINT = {                      +
            :uri => "https://gateway.developer.telekom.com/p3gw-mod-odg-voicebutler/services/VoiceButlerService",
            :version => 1
    }

    endpoint @@VOICE_CALL_SERVICE_ENDPOINT

    # Establish a voice call between two participants.
    # After a connection to the first participant has been successfully established the seccond particiant is called.
    # The call is established after the 2nd participant has picked up.
    #
    # ===Parameters
    # <tt>a_number</tt>:: Phone number of participant a.
    # <tt>b_number</tt>:: Phone number of participant b.
    # <tt>expiration</tt>:: Nr of seconds until the call will be canceled if no <tt>call_status</tt> call is received.
    # <tt>max_duration</tt>:: Maximum duration of the call in secons. In addition to this the system limit is applied.
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.
    # <tt>privacy_a</tt>:: Whether to show the phone number of participant a.
    # <tt>privacy_b</tt>:: Whether to show the phone number of participant b.
    # <tt>greeter</tt>:: Currently unused
    # <tt>account</tt>:: Currently unused
    def new_call(a_number, b_number, expiration, max_duration, environment = ServiceEnvironment.MOCK, privacy_a = false, privacy_b = false, greeter = "", account = "")
      response = invoke_authenticated("newCall") do |message, doc|
        message.add("request") do |request|
          request.add('environment', environment)
          request.add('aNumber', a_number)
          request.add('bNumber', b_number)
          request.add('privacyA', privacy_a.to_s)
          request.add('privacyB', privacy_b.to_s)
          request.add('expiration', expiration)
          request.add('maxDuration', max_duration)
          request.add('greeter', greeter)
          request.add('account', account)
        end
      end

      return VoiceCallResponse.new(response)
    end

    # Retrieve information about a specific call.
    # ===Parameters
    # <tt>session_id</tt>:: Session id of the call of interest.
    # <tt>environment</tt>:: Service environment as defined in ServiceEnvironment.
    # <tt>keep_alive</tt>:: Prevent an expiration of the call by calling <tt>call_status</tt> with <tt>keep_alive = 1</tt>.
    def call_status(session_id, environment = ServiceEnvironment.MOCK, keep_alive = 1)
      response = invoke_authenticated("callStatus") do |message, doc|
        message.add("request") do |request|
          request.add('environment', environment)
          request.add('keepAlive', keep_alive)
          request.add('sessionId', session_id)
        end
      end

      return CallStatusResponse.new(response)
    end

    # Cancels an ongoing call.
    # ===Parameters
    # <tt>session_id</tt>::
    # <tt>environment</tt>::  Service environment as defined in ServiceEnvironment.
    def teardown_call(session_id, environment = ServiceEnvironment.MOCK)
      response = invoke_authenticated("tearDownCall") do |message, doc|

        # Add namespace
        tdc = message.find("tearDownCall")
        tdc.set_attr("xmlns", "http://webservice.voicebutler.odg.tonline.de")

        message.add("request") do |request|
          request.add('environment', environment)
          request.add('sessionId', session_id)
        end
      end

      return CallStatusResponse.new(response)
    end

    # Establishes a voice call similar to <tt>newCall</tt>. <tt>b_number</tt> can be an array of numbers.
    # The service will call participants listed in <tt>b_number</tt> in sequence until sb. picks up.
    # ===Parameters
    # <tt>a_number</tt>:: Phone number of participant a.
    # <tt>b_number</tt>:: Phone number(s) of participant b. <tt>b_number</tt> can be an array of strings
    #     representing numbers or a single string representing a single number.
    # <tt>expiration</tt>:: Nr of seconds until the call will be canceled if no <tt>call_status</tt> with keepalive=true call is received.
    # <tt>max_duration</tt>:: Maximum duration of the call in secons. In addition to this the system limit is applied.
    # <tt>environment</tt>:: Service environment as defined in ServiceEnvironment.
    # <tt>privacy_a</tt>:: Whether to show the phone number of participant a.
    # <tt>privacy_b</tt>:: Whether to show the phone number of participant b.
    # <tt>max_wait</tt>:: Call the next participant after max_wait seconds.   
    # <tt>greeter</tt>:: Currently unused.
    # <tt>account</tt>:: Currently unused.
    def new_call_sequenced(a_number, b_number, expiration, max_duration, environment = ServiceEnvironment.MOCK, privacy_a = false, privacy_b = false, max_wait = 60, greeter = "", account = "")
      response = invoke_authenticated("newCallSequenced") do |message, doc|
        message.add("request") do |request|
          request.add('environment', environment)
          request.add('aNumber', a_number)

          # b_number can be an array of strings representing numbers or a single string representing a single number.
          if b_number.is_a? Array then
            # It's an array
            for bn in b_number do
              request.add('bNumber', bn)
            end
          else

            # We assume its a string
            request.add('bNumber', b_number)
          end

          request.add('privacyA', privacy_a.to_s)
          request.add('privacyB', privacy_b.to_s)
          request.add('expiration', expiration)
          request.add('maxDuration', max_duration)
          request.add('maxWait', max_wait)
          request.add('greeter', greeter)
          request.add('account', account)
        end
      end

      return VoiceCallResponse.new(response)
    end
  end
end