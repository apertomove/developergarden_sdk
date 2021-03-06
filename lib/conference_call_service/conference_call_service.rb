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
require File.dirname(__FILE__) + '/update_participant_response'
require File.dirname(__FILE__) + '/update_conference_response'
require File.dirname(__FILE__) + '/get_conference_template_response'
require File.dirname(__FILE__) + '/remove_conference_template_response'
require File.dirname(__FILE__) + '/get_conference_template_participant_response'
require File.dirname(__FILE__) + '/remove_conference_template_participant_response'
require File.dirname(__FILE__) + '/add_conference_template_participant_response'
require File.dirname(__FILE__) + '/update_conference_template_participant_response'
require File.dirname(__FILE__) + '/update_conference_template_response'
require File.dirname(__FILE__) + '/get_participant_status_response'


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

    # Add namespaces to the handsoap XmlMason document.
    def on_create_document(doc)
      super(doc)
      doc.alias 'cc', @@CONFERENCE_CALL_SCHEMA
    end

    # Stores the created conference to the conference call server.
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
            detail.add_to_handsoap_xml(detail_request)
          end

          # schedule
          if schedule then
            create_request.add('schedule') do |schedule_request|
              schedule.add_to_handsoap_xml(schedule_request)
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
    # <tt>what</tt>:: Constraints of the list to be retrieved.
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
    # <tt>conference_id</tt>:: Id of the conference of interest.
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

      response = GetConferenceStatusResponse.new(response_xml)
      return response
    end

    # Retrieves the status of the given participant in the specified conference.
    # ===Parameters
    # <tt>conference_id</tt>:: Id of the intended conference.
    # <tt>participant_id</tt>:: Id of the desired participant.
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.
    def get_participant_status(conference_id, participant_id, environment = ServiceEnvironment.MOCK, account = nil)
      response_xml = invoke_authenticated("cc:getParticipantStatus") do |request, doc|
        request.add('getParticipantStatusRequest') do |new_participant_request|
          new_participant_request.add('environment', environment)
          new_participant_request.add('account', account) if (account && !account.empty?)
          new_participant_request.add('conferenceId', conference_id.to_s)
          new_participant_request.add('participantId', participant_id)
        end
      end

      response = GetParticipantStatusResponse.new(response_xml)        
    end

    # Adds the given participant to the specified conference.
    # ===Parameters                                                                                                ra
    # <tt>conference_id</tt>:: Id of the intended conference.
    # <tt>participant</tt>:: Details of the participant to be added. 
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.
    def new_participant(conference_id, participant, environment = ServiceEnvironment.MOCK, account = nil)
      response_xml = invoke_authenticated("cc:newParticipant") do |request, doc|
        request.add('newParticipantRequest') do |new_participant_request|
          new_participant_request.add('environment', environment)
          new_participant_request.add('account', account) if (account && !account.empty?)
          new_participant_request.add('conferenceId', conference_id.to_s)
          new_participant_request.add('participant') do |participant_request|
            participant.add_to_handsoap_xml(participant_request)
          end
        end
      end

      response = NewParticipantResponse.new(response_xml)
    end

    # Updates the settings for the given participant of the given conference call.
    # ===Parameters
    # <tt>conference_id</tt>:: id of the interest conference
    # <tt>participant_id</tt>:: id of the coming participant
    # <tt>participant_detail</tt>:: Details of the coming participant
    # <tt>action</tt>:: Action to performed for the given participant. Actions are mute, umute and redial.
    #                   See ConferenceConstants for the corresponding constants.
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.
    def update_participant(conference_id, participant_id, participant_detail = nil, action = nil, environment = ServiceEnvironment.MOCK, account = nil)
      response_xml = invoke_authenticated("cc:updateParticipant") do |request, doc|
        request.add('updateParticipantRequest') do |update_participant_request|
          update_participant_request.add('environment', environment)
          update_participant_request.add('account', account) if (account && !account.empty?)
          update_participant_request.add('conferenceId', conference_id.to_s)
          update_participant_request.add('participantId', participant_id.to_s)
          update_participant_request.add('action', action.to_s) if action

          if participant_detail then
            update_participant_request.add('participant') do |participant_request|
              participant_detail.add_to_handsoap_xml(participant_request)
            end
          end
        end
      end

      response = UpdateParticipantResponse.new(response_xml)
    end

    # Removes the given conference.
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
    # <tt>what</tt>:: Constraints of the list to be retrieved.
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

    # Updates an existing conference.
    # ===Parameters
    # <tt>conference_id</tt>:: Id of the conference
    # <tt>conference_details</tt>:: Id of the conference
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.
    def update_conference(conference_id, conference_details = nil, schedule = nil, initiator_id = nil, environment = ServiceEnvironment.MOCK, account = nil)
      response_xml = invoke_authenticated("cc:updateConference") do |request, doc|
        request.add('updateConferenceRequest') do |remove_request|
          remove_request.add('environment', environment)
          remove_request.add('account', account) if (account && !account.empty?)
          remove_request.add('conferenceId', conference_id.to_s)
          remove_request.add('initiatorId', initiator_id.to_s)

          if conference_details then
            remove_request.add('detail') do |detail_request|
              conference_details.add_to_handsoap_xml(detail_request)
            end
          end

          if schedule then
            remove_request.add('schedule') do |schedule_request|
              schedule.add_to_handsoap_xml(schedule_request)
            end
          end
        end
      end

      response = UpdateConferenceResponse.new(response_xml)
    end

    # Tell whether a conference is running
    # ===Parameters
    # <tt>conference_id</tt>:: id of the maybe running conference
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

    # Creates a conference template.
    # ===Parameters
    # <tt>owner_id</tt>:: id of the owner of the conference template
    # <tt>detail</tt>:: details of the conference template. ConferenceDetails Type
    # <tt>participants</tt>:: optional parameter of the type ParticipantDetail
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.
    def create_conference_template(owner_id, detail, participants = nil, environment = ServiceEnvironment.MOCK,  account = nil)
      response_xml = invoke_authenticated("cc:createConferenceTemplate") do |request, doc|
        request.add('createConferenceTemplateRequest') do |create_conference_template_request|
          create_conference_template_request.add('environment', environment)
          create_conference_template_request.add('account', account) if (account && !account.empty?)
          create_conference_template_request.add('ownerId', owner_id.to_s)
          create_conference_template_request.add('detail') do |detail_request|
            detail.add_to_handsoap_xml(detail_request)
          end

          if participants then
            participants.each do |participant|
              create_conference_template_request.add('participants') do |participant_request|
                participant.add_to_handsoap_xml(participant_request)
              end
            end
          end
        end
      end

      response = CreateConferenceTemplateResponse.new(response_xml)
    end

    # Returns the confernece template with the given id.    
    # ===Parameters
    # <tt>template_id</tt>:: Id of the template of interest.
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.
    def get_conference_template(template_id, environment = ServiceEnvironment.MOCK,  account = nil)
      response_xml = invoke_authenticated("cc:getConferenceTemplate") do |request, doc|
        request.add('getConferenceTemplateRequest') do |get_conference_template_request|
          get_conference_template_request.add('environment', environment)
          get_conference_template_request.add('templateId', template_id.to_s)
          get_conference_template_request.add('account', account) if (account && !account.empty?)
        end
      end
      
      response = GetConferenceTemplateResponse.new(response_xml)
    end

    # Updates the specified conference with the given parameters.
    # ===Parameters
    # <tt>template_id</tt>:: id of the updated template
    # <tt>initiator_id</tt>:: id of the initiator of the conference
    # <tt>details</tt>:: details of the conference template
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.
    def update_conference_template(template_id, initiator_id, detail, environment = ServiceEnvironment.MOCK,  account = nil)
      response_xml = invoke_authenticated("cc:updateConferenceTemplate") do |request, doc|
        request.add('updateConferenceTemplateRequest') do |update_conference_template_request|
          update_conference_template_request.add('environment', environment)
          update_conference_template_request.add('templateId', template_id.to_s)
          update_conference_template_request.add('initiatorId', initiator_id.to_s)
          update_conference_template_request.add('detail') do |detail_request|
            detail.add_to_handsoap_xml(detail_request)
          end
          update_conference_template_request.add('account', account) if (account && !account.empty?)
        end
      end

      response = UpdateConferenceTemplateResponse.new(response_xml)
    end

    # ===Parameters
    # <tt>template_id</tt>:: template of the removed conference
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.
    def remove_conference_template(template_id, environment = ServiceEnvironment.MOCK,  account = nil)
      response_xml = invoke_authenticated("cc:removeConferenceTemplate") do |request, doc|
        request.add('getConferenceTemplateRequest') do |remove_conference_template_request|
          remove_conference_template_request.add('environment', environment)
          remove_conference_template_request.add('templateId', template_id.to_s)
          remove_conference_template_request.add('account', account) if (account && !account.empty?)
        end
      end
      
      response = RemoveConferenceTemplateResponse.new(response_xml)
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

    # Give the list of the templates of the given conference owner
    # ===Parameters
    # <tt>template_id</tt>:: id of the template in which we call the participant
    # <tt>participant_id</tt>:: id of the called participant
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.
    def get_conference_template_participant(template_id, participant_id, environment = ServiceEnvironment.MOCK, account = nil)
       response_xml = invoke_authenticated("cc:getConferenceTemplateParticipant") do |request, doc|
        request.add('getConferenceTemplateParticipantRequest') do |get_conference_template_participant_request|
          get_conference_template_participant_request.add('environment', environment)
          get_conference_template_participant_request.add('templateId', template_id.to_s)
          get_conference_template_participant_request.add('participantId', participant_id.to_s)
          get_conference_template_participant_request.add('account', account) if (account && !account.empty?)
        end
      end

      response = GetConferenceTemplateParticipantResponse.new(response_xml)
    end

    # Update the details of a given participant
    # ===Parameters
    # <tt>template_id</tt>:: id of the template in which we call the participant
    # <tt>participant_id</tt>:: id of the changed participant
    # <tt>participant</tt>:: details of the changed participant
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.
    def update_conference_template_participant(template_id, participant_id, participant, environment = ServiceEnvironment.MOCK, account = nil)
      response_xml = invoke_authenticated("cc:updateConferenceTemplateParticipant") do |request, doc|
        request.add('updateConferenceTemplateParticipantRequest') do |update_conference_template_participant_request|
          update_conference_template_participant_request.add('environment', environment)
          update_conference_template_participant_request.add('templateId', template_id.to_s)
          update_conference_template_participant_request.add('participantId', participant_id.to_s)
          update_conference_template_participant_request.add('participant') do |participant_request|
            participant.add_to_handsoap_xml(participant_request)
          end
          update_conference_template_participant_request.add('account', account) if (account && !account.empty?)
        end
      end

      response = UpdateConferenceTemplateParticipantResponse.new(response_xml)
    end

    # Give the list of the templates of the given conference owner
    # ===Parameters
    # <tt>template_id</tt>:: id of the template in which we call the participant
    # <tt>participant_id</tt>:: id of the called participant
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.
    def remove_conference_template_participant(template_id, participant_id, environment = ServiceEnvironment.MOCK, account = nil)
       response_xml = invoke_authenticated("cc:removeConferenceTemplateParticipant") do |request, doc|
        request.add('removeConferenceTemplateParticipantRequest') do |remove_conference_template_participant_request|
          remove_conference_template_participant_request.add('environment', environment)
          remove_conference_template_participant_request.add('templateId', template_id.to_s)
          remove_conference_template_participant_request.add('participantId', participant_id.to_s)
          remove_conference_template_participant_request.add('account', account) if (account && !account.empty?)
        end
      end

      response = RemoveConferenceTemplateParticipantResponse.new(response_xml)
    end

    # Give the list of the templates of the given conference owner
    # ===Parameters
    # <tt>template_id</tt>:: conference in which will be added the participant
    # <tt>participant</tt>:: participant who will be added to the conference
    # <tt>environment</tt>:: Service environment as defined in ServiceLevel.
    def add_conference_template_participant(template_id, participant, environment = ServiceEnvironment.MOCK, account = nil)
       response_xml = invoke_authenticated("cc:addConferenceTemplateParticipant") do |request, doc|
        request.add('addConferenceTemplateParticipantRequest') do |add_conference_template_participant_request|
          add_conference_template_participant_request.add('environment', environment)
          add_conference_template_participant_request.add('templateId', template_id.to_s)
          add_conference_template_participant_request.add('participant') do |participant_request|
            participant.add_to_handsoap_xml(participant_request)
          end
          add_conference_template_participant_request.add('account', account) if (account && !account.empty?)
        end
      end

      response = AddConferenceTemplateParticipantResponse.new(response_xml)
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