# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "developergarden_sdk/version"

Gem::Specification.new do |s|
  s.name        = "developergarden_sdk"
  s.version     = DevelopergardenSdk::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Julian Fischer / Aperto move GmbH", "Raphael Randschau"]
  s.email       = ['ruby@developergarden.com', 'nicolai86@me.com']
  s.homepage    = "http://www.developergarden.com"
  s.summary     = %q{Client library for the open development services of Deutsche Telekom AG. The services are: send SMS, voice call, conference call, IP location, local search and quota management. For more information, please see http://www.developergarden.com.}
  s.description = s.summary

  s.rubyforge_project = "developergarden_sdk"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency('htmlentities', '>= 4.0.0')
  s.add_dependency('handsoap', '1.1.4')
  s.add_dependency('nokogiri', '>= 1.4.0')
  s.add_dependency('httpclient', '2.1.5.2')
end
