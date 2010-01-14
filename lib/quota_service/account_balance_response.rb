class AccountBalanceResponse < BasicResponse
  attr_accessor :account_balances

  # Constructor.
  # ===Parameters
  # <tt>response_xml</tt>:: Xml as returned by a <tt>call_status</tt>-method call.
  # <tt>raise_exception_on_error</tt>:: Xml as returned by a <tt>call_status</tt>-method call.
  def initialize(response_xml, raise_exception_on_error = true)
    doc = response_xml.document

    @error_code       = doc.xpath("//errorCode").to_s
    @error_message    = doc.xpath("//errorMessage").to_s
    @account_balances = []

    # Get a list of all account sections
    accounts_xml = doc.xpath("//getAccountBalanceResponse/Account")

    # Create Account objects out of the xml response
    if accounts_xml.is_a?(Handsoap::XmlQueryFront::NodeSelection) then
      accounts_xml.each do |account_xml|
        account = Account.build_from_xml(account_xml)        
        account_balances << account
        puts account.to_s
      end
    end

    raise_on_error(response_xml) if raise_exception_on_error
  end
end

class Account
  attr_accessor :account, :credits

  def initialize(account, credits)
    @account = account
    @credits = credits
  end

  def self.build_from_xml(xml_doc)    
    account = xml_doc.xpath("Account").to_s
    credits = xml_doc.xpath("Credits").to_s
    return Account.new(account, credits)
  end

  def to_s
    self.inspect
  end
end