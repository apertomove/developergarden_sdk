#!/usr/bin/env ruby

require 'rubygems'
require 'developergarden_sdk'

voice_call_service = VoiceCallService::VoiceCallService.new("<USERNAME>@t-online.de", "<PASSWORD>")
voice_call = voice_call_service.new_call("+496978082205", "+496814413", 0, 600, ServiceEnvironment.PRODUCTION)

100.times do |i|
  status = voice_call_service.call_status(voice_call.session_id, ServiceEnvironment.PRODUCTION, keep_alive = 1)

  # Don't poll too often since this might cause strange effects in your app.
  sleep 5
end