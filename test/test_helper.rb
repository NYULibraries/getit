ENV["RAILS_ENV"] = 'test'
require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start 'rails'

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

@@aleph_url = "aleph.library.nyu.edu"
@@aleph_bor_id = "N12162279"
@@aleph_verification = "d4465aacaa645f2164908cd4184c09f0"
@@primo_url = "bobcat.library.nyu.edu"
@@solr_url = "index.websolr.com/solr/f0fdfe03534"

without_ctx_tim = VCR.request_matchers.uri_without_param(:ctx_tim)
VCR.configure do |c|
  c.cassette_library_dir = 'test/vcr_cassettes'
  # webmock needed for HTTPClient testing
  c.hook_into :webmock 
  c.register_request_matcher(:uri_without_ctx_tim, &without_ctx_tim)
  # c.debug_logger = $stderr
  c.filter_sensitive_data("aleph.library.edu") { @@aleph_url }
  c.filter_sensitive_data("BOR_ID") { @@aleph_bor_id }
  c.filter_sensitive_data("VERIFICATION") { @@aleph_verification }
  c.filter_sensitive_data("primo.library.edu") { @@primo_url }
  c.filter_sensitive_data("solr.library.edu") { @@solr_url }
end
