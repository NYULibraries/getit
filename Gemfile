source :rubygems
gem "rails", "~> 3.2.11"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "sass-rails",   "~> 3.2.5"
  gem "coffee-rails", "~> 3.2.2"
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  platforms :jruby do
    gem "therubyrhino", "~> 2.0.2"
  end
  platforms :ruby do
    gem "therubyracer", "~> 0.11.1"
  end
  gem "uglifier", ">= 1.3.0"
  gem "compass-rails", "~> 1.0.3"
  gem "nyulibraries_assets", :git => "git://github.com/NYULibraries/nyulibraries_assets.git"
  # gem "nyulibraries_assets", :path => "/Users/dalton/Documents/workspace/nyulibraries_assets"
end

# Testing gems
group :development, :test do
  gem "progress_bar", "~> 0.4.0"
  gem "simplecov", "~> 0.7.1"
  gem "simplecov-rcov", "~> 0.2.3"
  gem "vcr", "~> 2.4.0"
  gem "webmock", "~> 1.9.0"
end

platforms :jruby do
  gem "activerecord-jdbcmysql-adapter", "~> 1.2.5"
  gem "jruby-rack", "~> 1.1.12"
  gem "jruby-openssl", "~> 0.8.2"
end

platforms :ruby do
  gem "mysql2", "~> 0.3.11"
end

# Use jquery
gem "jquery-rails", "~> 2.1.4"

# Use mustache
gem "mustache-rails", "~> 0.2.3", :require => "mustache/railtie"

# Deploy with Capistrano
gem "capistrano", "~> 2.14.1"
gem "rvm-capistrano", "~> 1.2.7"

# Use passenger as the app server
gem "passenger", "~> 3.0.19"

# Umlaut
gem "umlaut", :git => "git://github.com/team-umlaut/umlaut.git", :branch => "bootstrap"
# gem "umlaut", :path => "/Users/dalton/Documents/workspace/umlaut/umlaut3"
gem "sunspot_rails", "~> 1.3.3"

# NYU customization gems
# gem "exlibris-primo", :git => "git://github.com/scotdalton/exlibris-primo.git"
# gem "exlibris-primo", :path => "/Users/dalton/Documents/workspace/gems/exlibris-primo"
gem "exlibris-aleph", "~> 0.1.6"
# gem "exlibris-aleph", :path => "/Users/dalton/Documents/workspace/gems/exlibris-aleph"
gem "authpds-nyu", "~> 0.2.5"

# Dalli for caching with memcached
gem "dalli", "~> 2.6.0"
