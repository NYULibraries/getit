source "https://rubygems.org"
gem "rails", "~> 3.2.13"
gem "json", "~> 1.7.7"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "sass-rails",   "~> 3.2.6"
  gem "coffee-rails", "~> 3.2.2"
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  platforms :jruby do
    gem "therubyrhino", "~> 2.0.2"
  end
  platforms :ruby do
    gem "therubyracer", "~> 0.11.1"
  end
  gem "uglifier", "~> 2.1.0"
  gem "compass-rails", "~> 1.0.3"
  gem "nyulibraries_assets", :git => "git://github.com/NYULibraries/nyulibraries_assets.git", :tag => "v1.1.12"
end

# Development gems
group :development do
  gem "progress_bar", "~> 1.0.0"
  gem "better_errors", "~> 0.8.0"
  gem "binding_of_caller", "~> 0.7.1", platform: :ruby
  gem "debugger", "~> 1.5.0", platform: :mri
  gem "ruby-debug", "~> 0.10.4", platform: :jruby
end

# Testing gems
group :test do
  gem "simplecov", "~> 0.7.1"
  gem "simplecov-rcov", "~> 0.2.3"
  gem 'coveralls', "~> 0.6.7", require: false
  gem "vcr", "~> 2.4.0"
  gem "webmock", "~> 1.9.0"
end

platforms :jruby do
  gem "jruby-rack", "~> 1.1.12"
  gem "activerecord-jdbcmysql-adapter", "~> 1.2.5"
end

platforms :ruby do
  gem "mysql2", "~> 0.3.11"
end

# Use jquery
gem "jquery-rails", "~> 2.2.1"

# Use mustache
gem "mustache-rails", "~> 0.2.3", :require => "mustache/railtie"

# Deploy with Capistrano
gem "rvm-capistrano", "~> 1.3.0"
gem "rake_nyu", :git => "git://github.com/NYULibraries/rake_nyu.git"

# For config settings
gem "rails_config", "~> 0.3.2"

# Use passenger as the app server
gem "passenger", "~> 4.0.0"

# Umlaut
gem "umlaut", :git => "git://github.com/team-umlaut/umlaut.git", :branch => "bootstrap"
# gem "umlaut-primo", "~> 0.1.0"
gem "umlaut-primo", :git => "git://github.com/team-umlaut/umlaut-primo.git"
gem "sunspot_rails", "~> 1.3.3"

# NYU customization gems
gem "exlibris-nyu", :git => "git://github.com/NYULibraries/exlibris-nyu.git", :branch => 'development'
gem "authpds-nyu", :git => "git://github.com/scotdalton/authpds-nyu.git"
# gem "authpds-nyu", "~> 0.2.11"

# Dalli for caching with memcached
gem "dalli", "~> 2.6.0"

# New Relic performance monitoring
gem "newrelic_rpm", "~> 3.6.0"
