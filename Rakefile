#
# To change this template, choose Tools | Templates
# and open the template in the editor.


require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require 'fileutils'

spec = Gem::Specification.new do |s|
  s.name = 'developergarden_sdk'
  s.version = '0.9.1'
  s.homepage = 'http://www.developergarden.com'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README', 'LICENSE']
  s.summary = 'Offers a ruby client for the open development services such as send SMS, voice call and quota management of the Deutsche Telekom AG. See also http://www.developergarden.com.'
  s.description = s.summary
  s.author = 'Julian Fischer / Aperto move GmbH'
  s.email = 'ruby@developergarden.com'
  # s.executables = ['your_executable_here']

  # GEM dependencies
  s.add_dependency 'httpclient', '= 2.1.5.2'
  s.add_dependency 'nokogiri', '>= 1.4.0'
  s.add_dependency 'handsoap', '= 1.1.4'
  s.add_dependency 'htmlentities', '>= 4.0.0'

  s.files = %w(LICENSE README Rakefile) + Dir.glob("{bin,lib,spec}/**/*")
  s.require_path = "lib"
  s.bindir = "bin"
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

Rake::RDocTask.new do |rdoc|
  files =['README', 'LICENSE', 'lib/**/*.rb']
  rdoc.rdoc_files.add(files)
  rdoc.main = "README" # page to start on
  rdoc.title = "developergarden_sdk Docs"
  rdoc.rdoc_dir = 'doc/rdoc' # rdoc output folder
  rdoc.options << '--line-numbers'
  rdoc.options << '--all'
  rdoc.options << '--charset=UTF-8'
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*.rb']
end

desc "update_plugin"
task :update_plugin do
  sh %{ rm -R plugin/developergarden_sdk/lib/* }
  sh %{ rm -R plugin/developergarden_sdk/test/* }
  sh %{ cp -R lib/* plugin/developergarden_sdk/lib/ }
  sh %{ cp -R test/* plugin/developergarden_sdk/test/ }
end

