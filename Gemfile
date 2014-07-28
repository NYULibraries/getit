source 'https://rubygems.org'
gem 'rails', '~> 3.2.18'
gem 'json', '~> 1.8.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', '~> 0.12.0'
  gem 'uglifier', '~> 2.5.0'
  gem 'sass-rails',   '~> 3.2.6'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'compass-rails', '~> 1.1.0'
  gem 'nyulibraries-assets', git: 'git://github.com/NYULibraries/nyulibraries-assets.git', tag: 'v2.1.6'
end

# Development gems
group :development do
  gem 'progress_bar', '~> 1.0.0'
  gem 'better_errors', '~> 1.0.1'
  gem 'binding_of_caller', "~> 0.7.2"
end

# Testing gems
group :development, :test, :cucumber do
  # Rspec as the test framework
  gem 'rspec-rails', '~> 3.0.0'
  # Use factory girl for creating models
  gem 'factory_girl_rails', '~> 4.4.0'
  gem 'cucumber-rails', '~> 1.4.0', require: false
  gem 'database_cleaner', '~> 1.3.0'
  gem 'selenium-webdriver', '~> 2.42.0'
  gem 'coveralls', '~> 0.7.0', require: false
  # Use pry-debugger as the REPL and for debugging
  gem 'pry-debugger', '~> 0.2.0'
end

group :test, :cucumber do
  gem 'vcr', '~> 2.9.0'
  gem 'webmock', '~> 1.18.0'
end

# Use MySQL
gem 'mysql2', '~> 0.3.13'

# Use jquery
gem 'jquery-rails', '~> 3.1.0'

# Use mustache
# Fix to 0.99.4 cuz 0.99.5 broke my shit.
gem 'mustache', '0.99.4'
gem 'mustache-rails', git: 'git://github.com/josh/mustache-rails.git', tag: 'v0.2.3', require: 'mustache/railtie'

# Deploy with NYU Libraries deploy recipes
gem 'nyulibraries-deploy', git: 'git://github.com/NYULibraries/nyulibraries-deploy.git' , branch: 'development-fig'

# Figs for configuration
gem 'figs', '~> 2.0.0'

# Use passenger as the app server
gem 'passenger', '~> 4.0.0'

# Umlaut
gem 'umlaut', '~> 3.3.0'
gem 'umlaut-primo', '~> 0.1.2'
gem 'sunspot_rails', '~> 2.1.0'

# NYU customization gems
gem 'exlibris-nyu', git: 'git://github.com/NYULibraries/exlibris-nyu.git', tag: 'v2.1.1'
gem 'authpds-nyu', git: 'git://github.com/NYULibraries/authpds-nyu.git', tag: 'v2.0.1'

# Dalli for caching with memcached
gem 'dalli', '~> 2.7.0'

# New Relic performance monitoring
gem 'newrelic_rpm', '~> 3.9.0'
