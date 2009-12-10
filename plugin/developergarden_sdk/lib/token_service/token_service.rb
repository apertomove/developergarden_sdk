require File.dirname(__FILE__) + '/../basic_service'
require File.dirname(__FILE__) + '/../token_service/security_token_validator'

Handsoap.http_driver = :httpclient

# Print http and soap requests and reponses if ruby has been started with -d option.
Handsoap::Service.logger = $stdout if $DEBUG

# Module defining a client to access the security token service.
module TokenService

  # TokenService client to perform authentication against the security token service.
  # Authentication is performed in two steps:
  # 1. Call <tt>login</tt> to gather an intermediate token
  # 2. Call <tt>getTokens</tt> to gather one or more security token(s).
  # 3. Call any service method passing the security token(s) along the soap header.
  # The security token service is an implementation of the OASIS WSS specification.
  # See also: http://www.oasis-open.org/committees/wss/.
  #
  # Be aware that all security information is provided in the soap header not in the soap body.
  # This is why a wss enabled service does not provide a separate method parameter to pass the security tokens.
  # As mentioned before security is passed in the soap header, instead.
  #   
  class TokenService < BasicService

    @@TOKEN_SERVICE_ENDPOINT = {
            :uri => 'https://sts.idm.telekom.com/TokenService',
            :version => 1
    }

    endpoint @@TOKEN_SERVICE_ENDPOINT

    # This is disabled per default because client time and server time need to be in sync
    # to use this function. Otherwise local token verification might fail even on valid tokens.
    # This would imply an unnecessary call to the token service.
    @@PERFORM_LOCAL_TOKEN_CHECKS = false

    # Create some namespace attributes 
    on_create_document do |doc|

      # doc is of type XmlMason::Document
      doc.alias 'ns1', "http://stss.idm.telekom.com/schema/"
      doc.alias 'xmlns:ns2', "Security"
    end

    # Call the the security token service to gather an intermediate token.
    def login
      response = invoke("login") do |message|
        doc = message.document

        # Build the login header
        build_login_header(doc)
      end

      intermediate_token = parse_token_data(response)

      return intermediate_token
    end

    #### Composite methods

    # Check whether there is a security token. Authenticate if not.
    # Reauthenticates if the security token has expired.
    # ===Returns
    # Security token as plain text/xml.
    def get_security_token

      # Reauthenticates if the security token has expired.
      if @security_token.nil? then
        authenticate
      end

      # Look at the validity dates of the token and locally check whether the token is still valid.
      if @@PERFORM_LOCAL_TOKEN_CHECKS && SecurityTokenValidator.token_invalid?(@security_token) then
        authenticate
      end

      return @security_token
    end

    protected

        # Performs a two step authentication gathering an intermediate token and then the actual security token.
    # The security token is used to make further service calls.
    # ===Returns
    # Security token as plain text/xml.
    def authenticate
      intermediate_token = login
      @security_token = get_tokens(intermediate_token)

      return @security_token
    end

        # Invokes the getTokens method using an intermediate token to gather security token(s).
    # Security tokens are needed to perform further service calls.
    # ===Parameters
    # <tt>intermediate_token</tt>:: Intermediate token gathered by invoking the <tt>login</tt>-Method
    def get_tokens(intermediate_token)
      response = invoke("getTokens") do |message|
        doc = message.document

        # Build the login header
        build_get_tokens_header(doc, intermediate_token)

        message.add('ns1:serviceId', @@SERVICE_ID)
      end

      security_token = parse_token_data(response)

      return security_token
    end

    # Builds the header including the username/password token
    # to call the login method in order to gather an intermediate token.
    #
    # The header of the given document will be enhanced so there is no need to
    # process the returning value.
    # ===Parameters
    # <tt>doc</tt>:: Request XmlMason document.
    def build_login_header(doc)

      # Get the header element
      header = build_security_header_common(doc)

      security = header.find('Security')
      security.add("UsernameToken")

      # Create username section
      username_token = security.find("UsernameToken")
      username_token.add("Username")
      username = username_token.find("Username")
      username.set_value(@username)

      # Create password section
      username_token.add("Password")
      password = username_token.find("Password")
      password.set_attr("Type", "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText")
      password.set_value(@password)

      return header
    end

    # Build the header using the intermediate_token to gather the security token(s).
    # This is part of the authentication process.
    #
    # The header of the given document will be enhanced so there is no need to
    # process the returning value.
    # ==Parameter
    # <tt>doc</tt>:: Request XmlMason document.
    # <tt>intermediate_token</tt>:: Intermediate token gathered by invoking the <tt>login</tt>-Method
    def build_get_tokens_header(doc, intermediate_token)

      # Get the header element
      header = build_security_header_common(doc)
      security = header.find("Security")
      security.set_value( intermediate_token, :raw )

      return header
    end

  end
end