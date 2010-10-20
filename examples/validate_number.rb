#!/usr/bin/env ruby -d

require 'rubygems'
require 'developergarden_sdk'

service = SmsService::SmsValidationService.new("<USER>@t-online.de", "<PASSWORD>")

message = "Das Keyword zur Validierung Ihrer Rufnummer lautet #key# und gültig bix #validUntil#."
number  = "+49-12345678"
originator = "McGuyver"

response = service.send_validation_keyword(message, number, originator, ServiceEnvironment.MOCK)

# No you receive an sms with the validation keyword

keyword = "SECRET"
response = service.validate(keyword, number, ServiceEnvironment.MOCK)

# No the number should be validated.

# Let verify this by having a look at the list of validated numbers:
response = service.get_validated_numbers(ServiceEnvironment.MOCK)

response.validated_numbers.each do |number|
  puts number.number + " is valid until " + number.validated_until
end