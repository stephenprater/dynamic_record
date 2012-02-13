require 'rubygems'
require 'rspec'
require 'active_support'
require 'active_record'

require 'spork'
require 'spork/ext/ruby-debug'
require 'term/ansicolor'

require 'logger'

module Kernel
  def logger
    ActiveRecord::Base.logger
  end
end

Spork.prefork do
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  #load our factorygirl monkey patches before we load the env 
  
  require 'pry'
  require 'database_cleaner'


  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[File.dirname(__FILE__) + ("/support/**/*.rb")].each {|f| require f}

  config = YAML::load(IO.read(File.dirname(__FILE__) + "/database.yml"))
  ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/test.log')
  ActiveRecord::Base.establish_connection(config["test"])
  load(File.dirname(__FILE__) + '/schema.rb')
  
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean

  RSpec.configure do |config|
    config.mock_with :rspec
  end
end

Spork.each_run do
  require 'factory_girl'
  FactoryGirl.reload
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean
end

