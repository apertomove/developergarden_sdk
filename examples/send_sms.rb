#!/usr/bin/env ruby -d

require 'rubygems'
require 'developergarden_sdk'

sms = SmsService::SmsService.new("<USER>@t-online.de", "<PASSWORD>")
sms_response = sms.send_sms("+49177 0000001", "Your message text.", "RubySDK", ServiceEnvironment.PRODUCTION, "")