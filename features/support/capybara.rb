# Configure Capybara
require 'capybara/poltergeist'
Capybara.configure do |config|
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, timeout: 120, js_errors: true, phantomjs_options: ['--load-images=no'])
  end
  # config.default_driver = :selenium
  config.default_driver = :poltergeist
  config.javascript_driver = :poltergeist
  Capybara.default_wait_time = 20
end
