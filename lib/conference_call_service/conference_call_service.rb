require File.dirname(__FILE__) + '/../authenticated_service'
require File.dirname(__FILE__) + '/conference_constants'
require File.dirname(__FILE__) + '/get_conference_list_response'

Handsoap.http_driver = :httpclient

# Print http and soap requests and reponses if ruby has been started with -d option.
Handsoap::Service.logger = $stdout if $DEBUG


module ConferenceCallService

  # Client to access the developer garden conference call service.
  #
  # See also:
  # * https://www.developergarden.com/openapi/conferencecall
  # * http://www.developergarden.com/static/docu/de/ch04s02s02.html 
  class ConferenceCallService < AuthenticatedService
    @@CONFERENCE_CALL_SCHEMA = 'http://ccs.developer.telekom.com/schema/'

    @@CONFERENCE_CALL_SCHEMA_SERVICE_ENDPOINT = {
            :uri => "https://gateway.developer.telekom.com/p3gw-mod-odg-ccs/services/ccsPort",
            :version => 1
    }

    endpoint @@CONFERENCE_CALL_SCHEMA_SERVICE_ENDPOINT


    def on_create_document(doc)
      super(doc)
      doc.alias 'cc', @@CONFERENCE_CALL_SCHEMA
    end


    def commit_conference

    end

    def create_conference(owner_id, detail, schedule = ConferenceSchedule.new)

    end


    # Retrieves spatial information about the given ip address.
    # ===Parameters
    # <tt>owner_id</tt>:: Return only items owned by the given user such as "max.mustermann".
    # <tt>what</tt>:: Contraints of the list to be retrieved.
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.
    # <tt>account</tt>:: IP address for which to perform an ip location.
    def get_conference_list(owner_id, what = ConferenceConstants.CONFERENCE_LIST_ALL, environment = ServiceEnvironment.MOCK, account = nil)
      response_xml = nil

      response_xml = invoke_authenticated("cc:getConferenceList") do |request, doc|
        request.add('getConferenceListRequest') do |list_request|
          list_request.add('environment', environment)
          list_request.add('what', what.to_s)
          list_request.add('ownerId', owner_id.to_s)
          list_request.add('account', account) if (account && !account.empty?)
        end
      end

      response = GetConferenceListResponse.new(response_xml)

      return response
    end

    def get_conference_status

    end

    def new_participant

    end

    def remove_conference

    end

    def remove_participant

    end

    def update_conference

    end

    def get_running_conference

    end

    def create_conference_template

    end

    def get_conference_template

    end

    def update_conference_template

    end

    def remove_conference_template

    end

    def get_conference_template_list

    end

    def get_conference_template_participant

    end

    def update_conference_template_participant

    end

    def remove_conference_template_participant

    end

    def add_conference_template_participant

    end


    #### Static Methods

    def self.CONFERENCE_CALL_SCHEMA
      return @@CONFERENCE_CALL_SCHEMA
    end

    # Performs a xpath query in the ip location namespace for the given document and query string.
    # === Parameters
    # <tt>doc</tt>:: XmlQueryFront document.
    # <tt>query_string</tt>:: Element to look for
    # <tt>global_search</tt>:: Searches within all levels using "//" if <tt>global_search = true</tt>.
    def self.xpath_query(doc, query_string, global_search = true)
      self.xpath_query_for_schema(@@CONFERENCE_CALL_SCHEMA, doc, query_string, global_search)
    end
  end
end

