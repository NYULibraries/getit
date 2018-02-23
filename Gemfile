source 'https://rubygems.org'

gem 'rails', '~> 4.2.7.1'

# Use MySQL for the database
gem 'mysql2', '~> 0.4.10'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.6'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 2.7.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# Use jQuery as the JavaScript library
gem 'jquery-rails', '~> 3.1.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', '~> 0.12.0'

# Use the NYU Libraries assets gem for shared NYU Libraries assets
gem 'nyulibraries_stylesheets', github: 'NYULibraries/nyulibraries_stylesheets', tag: 'v1.0.5'
gem 'nyulibraries_templates', github: 'NYULibraries/nyulibraries_templates', tag: 'v1.1.0'
gem 'nyulibraries_institutions', github: 'NYULibraries/nyulibraries_institutions', tag: 'v1.0.3'
gem 'nyulibraries_javascripts', github: 'NYULibraries/nyulibraries_javascripts', tag: 'v1.0.0'
gem 'nyulibraries_errors', github: 'NYULibraries/nyulibraries_errors', tag: 'v1.0.1'
# Use higher version of Compass CSS framework for sprites, etc.
gem 'compass-rails', '~> 2.0.0'

# Deploy the application with Formaggio deploy recipes
gem 'formaggio', github: 'NYULibraries/formaggio' , tag: 'v1.5.2'

# Umlaut
gem 'umlaut', '~> 4.1.0'
# gem 'umlaut', path: '/apps/umlaut'
gem 'umlaut-primo', '~> 1.0.0'
# Lock hashie in at 3.4.4 because > 3.4.5 breaks umlaut
# confstruct, a dependency of umlaut, has hashie as a dependency
# this was reported as a known issue but no one is looking into it ( we may have to ):
# https://github.com/team-umlaut/umlaut/pull/58
gem 'hashie', '3.4.4'

gem 'dalli', '~> 2.7.4'

gem 'umlaut_borrow_direct', '~> 1.0.2'

# Development gems
group :development do
  gem 'progress_bar', '~> 1.1.0'
  gem 'better_errors', '~> 2.3.0'
  gem 'binding_of_caller', "~> 0.7.2"
end

# Testing gems
group :development, :test, :cucumber do
  # Rspec as the test framework
  gem 'rspec-rails', '~> 3.6.0'
  # Use factory girl for creating models
  gem 'factory_girl_rails', '~> 4.8.0'
  # Use pry as the REPL
  gem 'pry', '~> 0.10.1'
  gem 'rb-readline'
  gem 'guard-rspec', require: false
  gem 'rspec-its', '~> 1.2.0'
end

group :test, :cucumber do
  # Phantomjs for headless browser testing
  gem 'phantomjs', '~> 2.1.1'
  gem 'poltergeist', '~> 1.16.0'
  # Use Coveralls.io to track testing coverage
  gem 'coveralls', '~> 0.8', require: false
  # Use VCR for testing with deterministic HTTP interactions
  gem 'vcr', '~> 3.0'
  gem 'webmock', '~> 3.0'
  # Use DatabaseCleaner for clearing the test database
  gem 'database_cleaner', '~> 1.3.0'
  # Use Selenium as the web driver for Cucumber
  gem 'selenium-webdriver', '~> 3.5'
  # Use Cucumber for integration testing
  gem 'cucumber-rails', '~> 1.5.0', require: false
end

# Use Sunspot for searching journals
gem 'rsolr', '~> 1'
gem 'sunspot_rails', '~> 2.2.7'

# NYU customization gems
gem 'exlibris-nyu', github: 'NYULibraries/exlibris-nyu', tag: 'v2.4.0'

# Use omniauth strategy for login with devise
gem 'omniauth-nyulibraries', github: 'NYULibraries/omniauth-nyulibraries',  tag: 'v2.1.1'
gem 'devise', '~> 3.5.4'

# Nokogiri
gem 'nokogiri', '~> 1.8.2'

# APM
gem 'newrelic_rpm'
gem 'rollbar'
