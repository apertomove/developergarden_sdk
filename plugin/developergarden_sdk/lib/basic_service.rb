require 'rubygems'
gem 'troelskn-handsoap'

require 'handsoap'
require File.dirname(__FILE__) + '/common/xml_tools'
require File.dirname(__FILE__) + '/service_environment'

# Implements basic logic used by developer garden ruby service implementations.
class BasicService < Handsoap::Service
  
  @@SERVICE_ID = "https://odg.t-online.de"

  # Create some namespaces
  on_create_document do |doc|
    doc.alias 'ns1', "http://sts.idm.telekom.com/schema/"
    doc.alias 'xmlns:ns2', "Security"
  end                     

  # Constructor
  # ===Parameters
  # <tt>username</tt>:: Username, such as myuser@t-online.de
  # <tt>password</tt>:: Password
  # <tt>environment</tt>:: Service environment as defined in ServiceEnvironment
  def initialize(username, password, environment = ServiceEnvironment.SANDBOX)
    @username = username
    @password = password
    @environment = environment
  end

  protected

  # After being successfully authenticated service calls need to performed including the security token(s) in its soap
  # headers. This method builds such a header.
  #
  # The header of the given document will be enhanced so there is no need to
  # process the returning value.
  #
  # ===Parameters
  # <tt>doc</tt>:: Request XmlMason document.
  # <tt>security_token</tt>:: Security tokens as plain text gathered using the TokenService.
  def build_service_header(doc, security_token)
    header = build_security_header_common(doc)
    security = header.find("Security")
    security.set_value( security_token, :raw)
    return header
  end

  # Regardless to whether it is a <tt>login</tt>, <tt>getTokens</tt> or a regular service call there always
  # has to be a security header. This method provides the structure which is in common to all these method calls.
  #
  # The header of the given document will be enhanced so there is no need to
  # process the returning value.
  # ===Parameters
  # <tt>doc</tt>:: Request XmlMason document.  
  def build_security_header_common(doc)
    
    # Get the header element
    header = doc.find('Header')

    # Add plain security element
    header.add('Security')

    # Find security element for further enhancement
    security = header.find('Security')

    # Set namespace
    security.set_attr("xmlns", "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd")
    security.set_attr("env:mustUnderstand", "1")
    return header
  end


  # Extracts any token from the response and returns it.
  # ===Parameters
  # <tt>response</tt>:: Response as returned from a <tt>getTokens</tt> call, for example.
  #
  # ==Return
  # Returns the security token as plain text to be inserted into a security header build with <tt>build_security_header_common</tt>. 
  def parse_token_data (response)

    # nokogiri document. Unfortunately it is unable to parse the returning xml completely.
    # Especially the body is not parsed completely.
    doc = response.document
    intermediate_token = doc.xpath("//schema:tokenData", "schema" => 'http://sts.idm.telekom.com/schema/').inner_text

    return intermediate_token
  end
end