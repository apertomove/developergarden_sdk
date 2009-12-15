require File.dirname(__FILE__) + '/../authenticated_service'
require File.dirname(__FILE__) + '/conference_constants'
require File.dirname(__FILE__) + '/conference_details'
require File.dirname(__FILE__) + '/conference_schedule'
require File.dirname(__FILE__) + '/get_conference_list_response'
require File.dirname(__FILE__) + '/create_conference_response'

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


    def commit_conference(conference_id, environment = ServiceEnvironment.MOCK)
      response_xml = invoke_authenticated("cc:commitConference") do |request, doc|
        request.add('commitConferenceRequest') do |commit_request, doc|
          commit_request.add('conferenceId', conference_id)
          commit_request.add('environment', environment)
        end
      end

      response = BasicResponse.new(response_xml)
    end

    # Creates a new conference.
    # ===Parameters
    # <tt>owner_id</tt>:: Return only items owned by the given user such as "max.mustermann".
    # <tt>detail</tt>:: Specifies the conference details like max duration, name and description.
    # <tt>schedule</tt>:: Specifies when the conference will take place and if its going to be repeated on a regular basis.    
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.        
    def create_conference(owner_id, detail, schedule = nil, environment = ServiceEnvironment.MOCK, account = nil)
      response_xml = invoke_authenticated("cc:createConference") do |request, doc|
        request.add('createConferenceRequest') do |create_request|
          create_request.add('environment', environment)
          create_request.add('ownerId', owner_id.to_s)
          create_request.add('detail') do |detail_request|
            detail_request.add('name', detail.name.to_s)
            detail_request.add('description', detail.description.to_s)
            detail_request.add('duration', detail.duration.to_s)
          end

          # schedule
          if schedule then
            create_request.add('schedule') do |schedule_request|
              schedule_request.add('minute', schedule.minute.to_s)
              schedule_request.add('hour', schedule.hour.to_s)
              schedule_request.add('dayOfMonth', schedule.day_of_month.to_s)
              schedule_request.add('month', schedule.month.to_s)
              schedule_request.add('year', schedule.year.to_s)
              schedule_request.add('recurring', schedule.recurring.to_s)
              schedule_request.add('notify', schedule.notify.to_s)
            end
          end

          create_request.add('account', account) if (account && !account.empty?)
        end
      end
      
      response = CreateConferenceResponse.new(response_xml)
    end


    # Retrieves spatial information about the given ip address.
    # ===Parameters
    # <tt>owner_id</tt>:: Return only items owned by the given user such as "max.mustermann".
    # <tt>what</tt>:: Contraints of the list to be retrieved.
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.
    # <tt>account</tt>:: IP address for which to perform an ip location.
    def get_conference_list(owner_id, what = ConferenceConstants.CONFERENCE_LIST_ALL, environment = ServiceEnvironment.MOCK, account = nil)

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

