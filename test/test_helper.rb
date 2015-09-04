# Wear merged coveralls for rails
require 'coveralls'
Coveralls.wear_merged!('rails')

ENV['RAILS_ENV'] = 'test'

require 'exlibris-nyu'
# Use the included test mnt for testing.
Exlibris::Aleph.configure do |config|
  config.table_path = "#{File.dirname(__FILE__)}/../test/mnt/aleph_tab"
end

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'factory_girl'
require 'pry'

# Make sure all Factories are loaded and actually work
FactoryGirl.reload

class ActionController::TestRequest
  def performed?; end

  def redirect_to(*args); end
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
VCR.configure do |c|
  c.cassette_library_dir = 'test/vcr_cassettes'
  # webmock needed for HTTPClient testing
  c.hook_into :webmock
  c.default_cassette_options =
    {match_requests_on: [:method, VCR.request_matchers.uri_without_param(:ctx_tim)]}
  # c.debug_logger = $stderr
  c.filter_sensitive_data('http://aleph.library.edu') { Exlibris::Aleph::Config.base_url }
  c.filter_sensitive_data('http://primo.library.edu') { Exlibris::Primo.config.base_url }
  c.filter_sensitive_data('http://solr.library.edu') { Sunspot.config.solr.url }
  c.filter_sensitive_data('AMAZON_API_KEY') { ENV['AMAZON_API_KEY'] }
  c.filter_sensitive_data('AMAZON_SECRET_KEY') { ENV['AMAZON_SECRET_KEY'] }
  c.filter_sensitive_data('AMAZON_ASSOCIATE_TAG') { ENV['AMAZON_ASSOCIATE_TAG'] }
  c.filter_sensitive_data('COVER_THING_DEVELOPER_KEY') { ENV['COVER_THING_DEVELOPER_KEY'] }
  c.filter_sensitive_data('GOOGLE_BOOK_SEARCH_API_KEY') { ENV['GOOGLE_BOOK_SEARCH_API_KEY'] }
  c.filter_sensitive_data('ISBN_DB_ACCESS_KEY') { ENV['ISBN_DB_ACCESS_KEY'] }
  c.filter_sensitive_data('NYU_SCOPUS_CITATIONS_JSON_API_KEY') { ENV['NYU_SCOPUS_CITATIONS_JSON_API_KEY']}
  c.filter_sensitive_data('NS_BX_TOKEN') { ENV['NS_BX_TOKEN'] }
  c.filter_sensitive_data('BOR_ID') { ENV['BOR_ID'] }
end
