source "https://rubygems.org"
gem "rails", "~> 3.2.14"
gem "json", "~> 1.8.0"

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
  gem "nyulibraries_assets", git: "git://github.com/NYULibraries/nyulibraries_assets.git", tag: "v1.2.0"
end

# Development gems
group :development do
  gem "progress_bar", "~> 1.0.0"
  gem "better_errors", "~> 1.0.1"
  gem "binding_of_caller", "~> 0.7.2", platform: :ruby
  gem "debugger", "~> 1.6.2", platform: :mri
  gem "ruby-debug", "~> 0.10.4", platform: :jruby
  gem 'pry'
end

# Testing gems
group :test do
  gem 'coveralls', "~> 0.7.0", require: false
  gem "vcr", "~> 2.5.0"
  gem "webmock", "~> 1.13.0"
end

platforms :jruby do
  gem "jruby-rack", "~> 1.1.13.2"
  gem "activerecord-jdbcmysql-adapter", "~> 1.3.1"
end

platforms :ruby do
  gem "mysql2", "~> 0.3.13"
end

# Use jquery
gem "jquery-rails", "~> 3.0.4"

# Use mustache
gem "mustache-rails", "~> 0.2.3", :require => "mustache/railtie"

# Deploy with NYU Libraries deploy recipes
gem "nyulibraries_deploy", git: "git://github.com/NYULibraries/nyulibraries_deploy.git",  tag: "v3.2.0"

# For config settings
gem "rails_config", "~> 0.3.3"

# Use passenger as the app server
gem "passenger", "~> 4.0.0"

# Umlaut
gem "umlaut", git: "git://github.com/team-umlaut/umlaut.git", branch: "bootstrap"
gem "umlaut-primo", "~> 0.1.2"
gem "sunspot_rails", "~> 2.0.0"

# NYU customization gems
gem "exlibris-nyu", git: "git://github.com/NYULibraries/exlibris-nyu.git", tag: 'v1.1.2'
gem "authpds-nyu", git: "git://github.com/NYULibraries/authpds-nyu.git", tag: 'v1.1.3'

# Dalli for caching with memcached
gem "dalli", "~> 2.6.0"

# New Relic performance monitoring
gem "newrelic_rpm", "~> 3.6.0"
