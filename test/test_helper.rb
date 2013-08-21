unless ENV['TRAVIS']
  require 'simplecov'
  require 'simplecov-rcov'
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start 'rails'
else
  require 'coveralls'
  Coveralls.wear!
end

ENV["RAILS_ENV"] = 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'authlogic'
require 'authlogic/test_case'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionController::TestRequest
  def performed?; end

  def redirect_to(*args); end
  
  # def logger
  #   Rails.logger
  # end
end

# Rails.logger.class_eval do
#   def error(msg)
#     raise msg
#   end
# end

# VCR is used to 'record' HTTP interactions with
# third party services used in tests, and play em
# back. Useful for efficiency, also useful for
# testing code against API's that not everyone
# has access to -- the responses can be cached
# and re-used. 
require 'vcr'
require 'webmock'

# To allow us to do real HTTP requests in a VCR.turned_off, we
# have to tell webmock to let us. 
WebMock.allow_net_connect!

@@aleph_url = Exlibris::Aleph::Config.base_url
@@primo_url = Settings.institutions.default.services.NYU_Primo.base_url
@@aws_access_key = Settings.institutions.default.services.Amazon.api_key
@@aws_secret_key = Settings.institutions.default.services.Amazon.secret_key
@@aws_associate_tag = Settings.institutions.default.services.Amazon.associate_tag
@@cover_thing_developer_key = Settings.institutions.default.services.CoverThing.developer_key
@@google_book_search_api_key = Settings.institutions.default.services.GoogleBookSearch.api_key
@@isbn_db_access_key = Settings.institutions.default.services.IsbnDb.access_key
@@nyu_scopus_api_key = Settings.institutions.NYU.services.ScopusCitations.json_api_key
@@ns_bx_token = Settings.institutions.NS.services.NS_bX.token

VCR.configure do |c|
  c.cassette_library_dir = 'test/vcr_cassettes'
  # webmock needed for HTTPClient testing
  c.hook_into :webmock 
  c.default_cassette_options = {
    :match_requests_on => [:method, VCR.request_matchers.uri_without_param(:ctx_tim)]
  }  
  # c.debug_logger = $stderr
  c.filter_sensitive_data("aleph.library.edu") { @@aleph_url }
  c.filter_sensitive_data("http://primo.library.edu") { @@primo_url }
  c.filter_sensitive_data("DUMMY_AWS_ACCESS_KEY_ID") { @@aws_access_key }
  c.filter_sensitive_data("DUMMY_AWS_SECRET_KEY") { @@aws_associate_tag }
  c.filter_sensitive_data("DUMMY_AWS_ASSOCIATE_TAG") { @@aws_associate_tag }
  c.filter_sensitive_data("DUMMY_COVER_THING_DEVELOPER_KEY") { @@cover_thing_developer_key }
  c.filter_sensitive_data("DUMMY_GOOGLE_BOOK_SEARCH_API_KEY") { @@google_book_search_api_key }
  c.filter_sensitive_data("DUMMY_ISBN_DB_ACCESS_KEY") { @@isbn_db_access_key }
  c.filter_sensitive_data("DUMMY_NYU_SCOPUS_API_KEY") { @@nyu_scopus_api_key }
  c.filter_sensitive_data("DUMMY_NS_BX_TOKEN") { @@ns_bx_token }
end

# Use the included testmnt for testing.
Exlibris::Aleph.configure do |config|
  config.tab_path = "#{File.dirname(__FILE__)}/../test/mnt/aleph_tab"
  config.yml_path = "#{File.dirname(__FILE__)}/../test/config/aleph"
end
