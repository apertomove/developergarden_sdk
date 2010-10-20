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

