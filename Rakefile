#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
GetIt::Application.load_tasks

if Rails.env.test?
  # RSpec deletes the test task as a default
  # We need to add it back here
  task default: :test
end

# We need to add the coveralls task in the Rakefile
# because we want to make sure we append it to the very
# end of the default task
if Rails.env.test?
  # Add the coveralls task as the default with the appropriate prereqs
  require 'coveralls/rake/task'
  Coveralls::RakeTask.new
  task default: 'coveralls:push'
end
