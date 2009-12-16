require File.dirname(__FILE__) + '/../authenticated_service'
require File.dirname(__FILE__) + '/conference_constants'
require File.dirname(__FILE__) + '/conference_details'
require File.dirname(__FILE__) + '/conference_schedule'
require File.dirname(__FILE__) + '/get_conference_list_response'
require File.dirname(__FILE__) + '/create_conference_response'
require File.dirname(__FILE__) + '/commit_conference_response'
require File.dirname(__FILE__) + '/get_conference_status_response'
require File.dirname(__FILE__) + '/new_participant_response'
require File.dirname(__FILE__) + '/participant_details'
require File.dirname(__FILE__) + '/remove_participant_response'
require File.dirname(__FILE__) + '/remove_conference_response'
require File.dirname(__FILE__) + '/get_running_conference_response'
require File.dirname(__FILE__) + '/participant'
require File.dirname(__FILE__) + '/get_conference_template_list_response'
require File.dirname(__FILE__) + '/create_conference_template_response'

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

    # ===Parameters
    # <tt>conference_id</tt>:: id of the interest conference
    # <tt>environment</tt>:: Service environment as defined in ServiceEnvironment.
    def commit_conference(conference_id, environment = ServiceEnvironment.MOCK)
      response_xml = invoke_authenticated("cc:commitConference") do |request, doc|
        request.add('commitConferenceRequest') do |commit_request, doc|
          commit_request.add('conferenceId', conference_id)
          commit_request.add('environment', environment)
        end
      end

      response = CommitConferenceResponse.new(response_xml)
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

    # Retrieves that status of the given conference.
    # ===Parameters
    # <tt>conference_id</tt>:: 
    # <tt>what</tt>:: Contraints of the list to be retrieved.
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.        
    def get_conference_status(conference_id, what = ConferenceConstants.CONFERENCE_LIST_ALL, environment = ServiceEnvironment.MOCK, account = nil)
      response_xml = invoke_authenticated("cc:getConferenceStatus") do |request, doc|
        request.add('getConferenceStatusRequest') do |status_request|
          status_request.add('environment', environment)
          status_request.add('what', what.to_s)
          status_request.add('conferenceId', conference_id.to_s)
          status_request.add('account', account) if (account && !account.empty?)
        end
      end

      puts response_xml.to_xml
      puts "\n\n----------\n\n"
      response = GetConferenceStatusResponse.new(response_xml)
      return response
    end

    # ===Parameters
    # <tt>conference_id</tt>:: id of the interest conference
    # <tt>participant_id</tt>:: id of the coming participant
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.
    def new_participant(conference_id, participant, environment = ServiceEnvironment.MOCK, account = nil)
      response_xml = invoke_authenticated("cc:newParticipant") do |request, doc|
        request.add('newParticipantRequest') do |new_participant_request|
          new_participant_request.add('environment', environment)
          new_participant_request.add('account', account) if (account && !account.empty?)
          new_participant_request.add('conferenceId', conference_id.to_s)
          new_participant_request.add('participant') do |participant_request|
            participant_request.add('firstName', participant.first_name.to_s)
            participant_request.add('lastName', participant.last_name.to_s)
            participant_request.add('number', participant.number.to_s)
            participant_request.add('email', participant.email.to_s)
            participant_request.add('flags', participant.flags.to_s)
          end
        end
      end

      response = NewParticipantResponse.new(response_xml)
    end

    # ===Parameters
    # <tt>conference_id</tt>:: id of the removed conference
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.
    def remove_conference(conference_id, environment = ServiceEnvironment.MOCK, account = nil)
      response_xml = invoke_authenticated("cc:removeConference") do |request, doc|
        request.add('removeConferenceRequest') do |remove_conference_request|
          remove_conference_request.add('environment', environment)
          remove_conference_request.add('conferenceId', conference_id.to_s)
          remove_conference_request.add('account', account) if (account && !account.empty?)
        end
      end

      response = RemoveConferenceResponse.new(response_xml)
    end

    # Retrieves that status of the given conference.
    # ===Parameters
    # <tt>conference_id</tt>::
    # <tt>what</tt>:: Contraints of the list to be retrieved.
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.    
    def remove_participant(conference_id, participant_id, environment = ServiceEnvironment.MOCK, account = nil)
      response_xml = invoke_authenticated("cc:removeParticipant") do |request, doc|
        request.add('removeParticipantRequest') do |remove_request|
          remove_request.add('environment', environment)
          remove_request.add('account', account) if (account && !account.empty?)
          remove_request.add('conferenceId', conference_id.to_s)
          remove_request.add('participantId', participant_id.to_s)
        end
      end

      response = RemoveParticipantResponse.new(response_xml)
    end

    def update_conference

    end

    # Tell whether a conference is running
    # ===Parameters
    # <tt>conference_id</tt>:: id of the may-be running conference
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.
    def get_running_conference(conference_id, environment = ServiceEnvironment.MOCK,  account = nil)
      response_xml = invoke_authenticated("cc:getRunningConference") do |request, doc|
        request.add('getRunningConferenceRequest') do |get_running_conference_request|
          get_running_conference_request.add('environment', environment)
          get_running_conference_request.add('conferenceId', conference_id.to_s)
          get_running_conference_request.add('account', account) if (account && !account.empty?)
        end
      end

      response = GetRunningConferenceResponse.new(response_xml)
    end

    # ===Parameters
    # <tt>owner_id</tt>:: id of the owner of the conference template
    # <tt>detail</tt>: details of the conference template. ConferenceDetails Type
    # <tt>participants</tt>: optional parameter of the type ParticipantDetail
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.
    def create_conference_template(owner_id, detail, participants = nil,  environment = ServiceEnvironment.MOCK,  account = nil)
      response_xml = invoke_authenticated("cc:createConferenceTemplate") do |request, doc|
        request.add('createConferenceTemplate') do |create_conference_template_request|
          create_conference_template_request.add('environment', environment)
          create_conference_template_request.add('account', account) if (account && !account.empty?)
          create_conference_template_request.add('ownerId', owner_id.to_s)
          create_conference_template_request.add('detail') do |detail_request|
              detail_request.add('name', detail.name.to_s)
              detail_request.add('description', detail.description.to_s)
              detail_request.add('duration', detail.duration.to_s)
            end
          end
          if participants
            participants.each do |participant|
              create_conference_template_request.add('participants') do |participant_request|
                participant_request.add('firstName', participant.first_name.to_s)
                participant_request.add('lastName', participant.last_name.to_s)
                participant_request.add('number', participant.number.to_s)
                participant_request.add('email', participant.email.to_s)
                participant_request.add('flags', participant.flags.to_s)
              end
            end
          end
          
        end
      end

      response = CreateConferenceTemplateResponse.new(response_xml)
      
    end

    def get_conference_template

    end

    def update_conference_template

    end

    def remove_conference_template

    end

    # Give the list of the templates of the given conference owner
    # ===Parameters
    # <tt>owner_id</tt>:: id of the owner of the requested conference
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.
    def get_conference_template_list(owner_id, environment = ServiceEnvironment.MOCK,  account = nil)
      response_xml = invoke_authenticated("cc:getConferenceTemplateList") do |request, doc|
        request.add('getConferenceTemplateListRequest') do |get_conference_template_list_request|
          get_conference_template_list_request.add('environment', environment)
          get_conference_template_list_request.add('ownerId', owner_id.to_s)
          get_conference_template_list_request.add('account', account) if (account && !account.empty?)
        end
      end

        response = GetConferenceTemplateListResponse.new(response_xml)
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

