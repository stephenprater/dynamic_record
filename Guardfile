# A sample Guardfile
# More info at https://github.com/guard/guard#readme
#
require 'ruby-debug'
require 'guard-legacy'

notification :growl

guard 'spork', :cucumber_env => { 'RAILS_ENV' => 'test' }, :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
  watch('spec/database.yml') { :rpsec }
  watch('spec/schema.rb') { :rpsec }
end

guard 'rspec', :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| spec = "spec/#{m[1]}_spec.rb"; puts "wanted to execute #{spec}" }
  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{^spec/factories/(.+)\.rb$}) { |m| "spec" }
end
