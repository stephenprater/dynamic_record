require 'rubygems'
require 'rspec'
require 'active_support'
require 'active_record'

require 'spork'
require 'spork/ext/ruby-debug'

require 'logger'

require 'factory_girl'

module Kernel
  def logger
    ActiveRecord::Base.logger
  end
end

Spork.prefork do
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  require 'pry'
  require 'database_cleaner'
  
  ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + "/database.yml"))
  ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/test.log')
  config = ActiveRecord::Base.configurations["dynamic_record"]
  ActiveRecord::Base.establish_connection(config)
  load(File.dirname(__FILE__) + '/schema.rb')

  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[File.dirname(__FILE__) + ("/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec
  end
end

Spork.each_run do
  
  load 'dynamic_record.rb'
  FactoryGirl.reload
  ActiveSupport::Dependencies.clear
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean
end

