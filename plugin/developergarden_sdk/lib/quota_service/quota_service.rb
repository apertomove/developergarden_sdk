require File.dirname(__FILE__) + '/../authenticated_service'
require File.dirname(__FILE__) + '/../quota_service/quota_information'
require File.dirname(__FILE__) + '/../quota_service/account_balance_response'

Handsoap.http_driver = :httpclient

# Print http and soap requests and reponses if ruby has been started with -d option. 
Handsoap::Service.logger = $stdout if $DEBUG

module QuotaService

  # Client to access the developer garden quota service.
  #
  # See also:
  # * https://www.developergarden.com/openapi/dokumentation/uebergreifende_informationen#2.5.
  # * https://www.developergarden.com/openapi/dokumentation/services#4.2.6.  
  class QuotaService < AuthenticatedService

    @@QUOTA_SERVICE_ENDPOINT = {
      :uri => "https://gateway.developer.telekom.com/p3gw-mod-odg-admin/services/ODGBaseUserService",
      :version => 1
    }

    endpoint @@QUOTA_SERVICE_ENDPOINT

    # Get the amount of remaining quota points.
    # ===Parameters
    # <tt>module_id</tt>:: module_id of the service for which a quota request to be made, such as "VoiceButlerProduction"
    def get_quota_information(module_id = "VoiceButlerSandbox")
      response = invoke_authenticated("getQuotaInformation") do |message, doc|
        message.add('moduleId', module_id)
      end
      quota_info = QuotaInformation.new(response)
      
      return quota_info
    end

    # Changes the quota for a particular service
    # ===Parameters
    # <tt>module_id</tt>:: module_id of the service for which a quota request to be made, such as "VoiceButlerProduction"
    # <tt>quota_max</tt>:: Quota limit to be set
    def change_quota_pool(module_id = "VoiceButlerSandbox", quota_max = 100)
      response = invoke_authenticated("changeQuotaPool") do |message, doc|
        message.add('moduleId', module_id)
        message.add('quotaMax', quota_max)
      end

      return BasicResponse.new(response)
    end

    # Get balance of the given developergarden account.
    # ===Parameters
    # <tt>account</tt>:: Account ids of the sub accounts to retrieve the balance for.
    #   Retrieves the balance of the main account if the account balance is empty.
    def get_account_balance(account = nil)
      response = invoke_authenticated("getAccountBalance") do |message, doc|
        message.add('account', account) if account        
      end

      return AccountBalanceResponse.new(response)
    end
  end
end