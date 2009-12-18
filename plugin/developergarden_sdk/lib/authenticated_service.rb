require File.dirname(__FILE__) + '/basic_service'
require File.dirname(__FILE__) + '/token_service/token_service'

# Base service for all services demanding a security token.
class AuthenticatedService < BasicService

  # Constructor
  # ===Parameters
  # <tt>username</tt>:: Username, such as myuser@t-online.de
  # <tt>password</tt>:: Password
  def initialize(username, password, environment = ServiceEnvironment.SANDBOX)
    super(username, password)

    @token_service = TokenService::TokenService.new(@username, @password)
  end

  # Invokes the given action and also adds the security token to the SOAP header.
  # Using this method authentication is totally hidden from the rest of the application.
  def invoke_authenticated(action, &block)

    security_token = @token_service.get_security_token

    response = invoke(action) do |message|
      doc = message.document
      
      # Build the login header
      build_service_header(doc, security_token)

      yield(message, doc)
    end

    return response
  end
end