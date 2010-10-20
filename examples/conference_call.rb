require 'rubygems'
require 'developergarden_sdk'

environment = ServiceEnvironment.PRODUCTION

service = ConferenceCallService::ConferenceCallService.new("<USERNAME>@t-online.de", "<PASSWORD>")

conf_details = ConferenceCallService::ConferenceDetails.new("A very important conf", "A very impressive description", 30)

response = service.create_conference("max.mustermann", conf_details, nil, environment)

conf_id = response.conference_id

participant = ConferenceCallService::ParticipantDetails.new('maxi', 'max', '<NUMBER A>', 'max@spin.to', 1)
participant2 = ConferenceCallService::ParticipantDetails.new('roger', 'beep', '<NUMBER B>', 'roger@spin.to', 0)

service.new_participant(conf_id, participant, environment)
service.new_participant(conf_id, participant2, environment)

service.commit_conference(conf_id, ServiceEnvironment.PRODUCTION)