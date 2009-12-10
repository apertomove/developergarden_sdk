require 'nokogiri'

module TokenService

  # Verifies the timestamp of a security token to determine whether the token
  # is yet or still valid.
  # This is done to avoid unnecessary 
  class SecurityTokenValidator

    # Verifies the timestamp of a security token to determine whether the token
    # is yet or still valid.
    # This is done to avoid unnecessary
    # === Parameters
    # <tt>security_token_xml</tt>:: Security token as plain xml.
    # === Returns
    # Boolean indicating whether the security token is yet or still valid.
    def self.token_valid?(security_token_xml)
      doc = Nokogiri.XML( security_token_xml )
      conditions_node_set = doc.xpath("//schema:Conditions", "schema" => 'urn:oasis:names:tc:SAML:2.0:assertion')
      conditions_elment = conditions_node_set.first
      not_before = conditions_elment.get_attribute('NotBefore')
      not_on_or_after = conditions_elment.get_attribute('NotOnOrAfter')

      date_not_before = DateTime.parse(not_before)
      date_not_on_or_after = DateTime.parse(not_on_or_after)

      # Should be: date_not_before =< now < date_not_on_or_after
      ret = DateTime.now.between?(date_not_before, date_not_on_or_after)
          
      return ret
    end

    # Verifies the timestamp of a security token to determine whether the token
    # is yet or still valid.
    # This is done to avoid unnecessary
    # === Parameters
    # <tt>security_token_xml</tt>:: Security token as plain xml.
    # === Returns
    # (logical) not token_valid?(security_token_xml)
    # Returns true if the security token is not valid!
    def self.token_invalid?(security_token_xml)
      return !(self.token_valid?(security_token_xml))
    end
  end

end