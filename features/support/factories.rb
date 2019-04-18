# Add the factories from RSpec
Cucumber::Rails::World.send(:include, FactoryBot::Syntax::Methods)
