# Configure Capybara
require 'capybara/poltergeist'
Capybara.configure do |config|
  # config.app_host = 'https://dev.login.library.nyu.edu'
  config.default_driver = :poltergeist
  # config.default_driver = :selenium
  Capybara.default_wait_time = 10
end
