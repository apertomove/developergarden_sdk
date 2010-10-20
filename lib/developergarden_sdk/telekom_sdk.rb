$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require File.dirname(__FILE__) + '/quota_service/quota_service'
require File.dirname(__FILE__) + '/voice_call_service/voice_call_service'
require File.dirname(__FILE__) + '/sms_service/sms_service'

module QuotaService
end

module SmsService
end

module VoiceCallService
end