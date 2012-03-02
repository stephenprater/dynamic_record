# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dynamic_record/version"

Gem::Specification.new do |s|
  s.name        = "dynamic_record"
  s.version     = DynamicRecord::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Stephen Prater"]
  s.email       = ["me@stephenprater.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Provides EAV style ActiveRecord Objects}
  s.description = %q{TODO: Create records with dynamic fields - easy to export, easy to query because
    they don't query out of the EAV tables, but instead create a standard column based materialized view
    with a dynamic ActiveRecord subclass.
  }

  s.rubyforge_project = "dynamic_record"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'activerecord', '>= 3.1'
  s.add_dependency 'activesupport', '>= 3.1'
  s.add_dependency 'mysql2'
  
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'spork'
  s.add_development_dependency 'database_cleaner'
  
  s.add_development_dependency 'ruby-debug'
  s.add_development_dependency 'pry'
  
  s.add_development_dependency 'growl'
end
