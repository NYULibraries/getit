# Add the factories from RSpec
require 'factory_girl'
rspec_dirname = "#{File.dirname(__FILE__)}/../../spec/factories/*_factory.rb"
Dir[rspec_dirname].each do |factory|
  require factory
end
Cucumber::Rails::World.send(:include, FactoryGirl::Syntax::Methods)
