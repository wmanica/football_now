require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
task default: :spec

Dir.glob("#{File.dirname(__FILE__)}/app/lib/tasks/*.rake").each { |r| import r }
