source 'https://rubygems.org'

gem 'rails', '~> 4.1.0'

# Use MySQL for the database
gem 'mysql2', '~> 0.3.13'

# Use SCSS for stylesheets
gem 'sass-rails', '>= 5.0.0.beta1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 2.5.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# Use jQuery as the JavaScript library
gem 'jquery-rails', '~> 3.1.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', '~> 0.12.0'

# Use the Compass CSS framework for sprites, etc.
gem 'compass-rails', '~> 2.0.0'

# Use mustache for templating
# Fix to 0.99.4 cuz 0.99.5 broke my shit.
gem 'mustache', '0.99.4'
gem 'mustache-rails', github: 'josh/mustache-rails', tag: 'v0.2.3', require: 'mustache/railtie'

# Use the NYU Libraries assets gem for shared NYU Libraries assets
gem 'nyulibraries-assets', github: 'NYULibraries/nyulibraries-assets', tag: 'v4.0.2'

# Deploy the application with Formaggio deploy recipes
gem 'formaggio', github: 'NYULibraries/formaggio' , tag: 'v1.0.0'

# Use Figs for setting the configuration in the Environment
gem 'figs', '~> 2.0.2'

# Umlaut
gem 'umlaut', '~> 4.0.0'
gem 'umlaut-primo', '~> 1.0.0'

# Development gems
group :development do
  gem 'progress_bar', '~> 1.0.0'
  gem 'better_errors', '~> 2.0.0'
  gem 'binding_of_caller', "~> 0.7.2"
end

# Testing gems
group :development, :test, :cucumber do
  # Rspec as the test framework
  gem 'rspec-rails', '~> 3.1.0'
  # Use factory girl for creating models
  gem 'factory_girl_rails', '~> 4.5.0'
  # Use pry as the REPL
  gem 'pry', '~> 0.10.1'
end

group :test, :cucumber do
  # Use Coveralls.io to track testing coverage
  gem 'coveralls', '~> 0.7.0', require: false
  # Use VCR for testing with deterministic HTTP interactions
  gem 'vcr', '~> 2.9.0'
  gem 'webmock', '~> 1.19.0'
  # Use DatabaseCleaner for clearing the test database
  gem 'database_cleaner', '~> 1.3.0'
  # Use Selenium as the web driver for Cucumber
  gem 'selenium-webdriver', '~> 2.43.0'
  # Use Cucumber for integration testing
  gem 'cucumber-rails', '~> 1.4.0', require: false
end

# Use Sunspot for searching journals
gem 'sunspot_rails', '~> 2.1.0'

# NYU customization gems
gem 'exlibris-nyu', github: 'NYULibraries/exlibris-nyu', branch: 'v2.1.2'
gem 'authpds-nyu', github: 'NYULibraries/authpds-nyu', tag: 'v2.0.1'

# Dalli for caching with memcached
gem 'dalli', '~> 2.7.0'

# New Relic performance monitoring
gem 'newrelic_rpm', '~> 3.9.0'
