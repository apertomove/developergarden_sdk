#!/usr/bin/env ruby

require 'test/unit'
require File.dirname(__FILE__) + '/../lib/token_service/token_service'
require File.dirname(__FILE__) + '/../lib/token_service/security_token_validator'

class TokenServiceTest < Test::Unit::TestCase
 
  # Loading username/password for Tests from config file. Section: account
  ACCOUNT = YAML.load_file(File.dirname(__FILE__) + "/../config/test_settings.yml")["account"]

  def initialize(test_method_name)
    @t = TokenService::TokenService.new(ACCOUNT["username"], ACCOUNT["password"])
    super(test_method_name)
  end

  # Tests the login method by verifying whether there is an "Assertion" keyword in the returning string.
  # The assertion keyword is a mandatory part of the excpected intermediate token xml.
  def test_login
    intermediate_token = @t.login
    
    assert_match(/Assertion/, intermediate_token, "Expected to find the Assertion tag in the intermediate token but didn't find it.")
  end
  
  # A get_security_token with invalid credentials should cause a Handsoap::Fault exception
  # Faulstring: 'The security token could not be authenticated or authorized.'
  def test_get_security_token_invalid_credentials
    @t_invalid = TokenService::TokenService.new(ACCOUNT["username"], "wrong_password")

    assert_raises(Handsoap::Fault) do
      @t_invalid.get_security_token
    end
  end

  # A get_security_token with invalid credentials should cause a Handsoap::Fault exception
  # Faulstring will be something like: "Did not understand "MustUnderstand" header(s) ..."
  def test_get_security_token_missing_credentials
    @t_invalid = TokenService::TokenService.new(nil, nil)

    assert_raises(Handsoap::Fault) do
      @t_invalid.get_security_token
    end
  end

  # Tests a security token which is definitely out of date
  def test_token_invalid
    # Load an outdated securit token
    invalid_security_token_xml = open(File.dirname(__FILE__) + "/fixtures/assertion_invalid.xml")
    assert_equal(true, TokenService::SecurityTokenValidator.token_invalid?(invalid_security_token_xml))
  end

  # Tests a security token whith a huge time scope --> until 2099
  def test_token_valid

    # Load a valid securit token
    valid_security_token_xml = open( File.dirname(__FILE__) + "/fixtures/assertion_valid.xml")
    assert_equal(true, TokenService::SecurityTokenValidator.token_valid?(valid_security_token_xml))
  end
end