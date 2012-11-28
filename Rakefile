require 'bundler'

require 'rspec'
require 'rspec/core/rake_task'
require 'rspec/autorun'
require 'rcov'

Bundler::GemHelper.install_tasks

namespace(:spec) do
  desc "run all specs with rcov"
  RSpec::Core::RakeTask.new(:coverage) do |t|
    t.pattern = 'spec/**/*_spec.rb'
    t.rspec_opts = ["--profile","--format progress","--no-drb"]
    t.rcov = true
    t.rcov_opts =  %q[--exclude "spec" --text-summary]
    t.verbose = true
  end
end

task :default => :spec
