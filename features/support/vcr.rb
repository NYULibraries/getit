require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.ignore_hosts '127.0.0.1', 'localhost'
  c.cassette_library_dir = 'features/cassettes'
  c.filter_sensitive_data('http://aleph.library.edu') { Exlibris::Aleph::Config.base_url }
  c.filter_sensitive_data('http://primo.library.edu') { Exlibris::Primo::Config.base_url }
  c.filter_sensitive_data('https://login.library.edu') { UserSession.pds_url }
  c.filter_sensitive_data('http://solr.library.edu') { Sunspot.config.solr.url }
  c.filter_sensitive_data('AMAZON_API_KEY') { ENV['AMAZON_API_KEY'] }
  c.filter_sensitive_data('AMAZON_SECRET_KEY') { ENV['AMAZON_SECRET_KEY'] }
  c.filter_sensitive_data('AMAZON_ASSOCIATE_TAG') { ENV['AMAZON_ASSOCIATE_TAG'] }
  c.filter_sensitive_data('COVER_THING_DEVELOPER_KEY') { ENV['COVER_THING_DEVELOPER_KEY'] }
  c.filter_sensitive_data('GOOGLE_BOOK_SEARCH_API_KEY') { ENV['GOOGLE_BOOK_SEARCH_API_KEY'] }
  c.filter_sensitive_data('ISBN_DB_ACCESS_KEY') { ENV['ISBN_DB_ACCESS_KEY'] }
  c.filter_sensitive_data('NYU_SCOPUS_CITATIONS_JSON_API_KEY') { ENV['NYU_SCOPUS_CITATIONS_JSON_API_KEY'] }
  c.filter_sensitive_data('NS_BX_TOKEN') { ENV['NS_BX_TOKEN'] }
  c.filter_sensitive_data('PDS_HANDLE') { ENV['PDS_HANDLE'] }
  c.filter_sensitive_data('BOR_ID') { ENV['BOR_ID'] }
  c.default_cassette_options = {match_requests_on: [:method, VCR.request_matchers.uri_without_param(:ctx_tim)]}
end

VCR.cucumber_tags do |t|
  # Uses default record mode since no options are given
  t.tag '@guest/new_yorker'
  t.tag '@guest/vogue'
  t.tag '@guest/not_by_reason_alone'
  t.tag '@guest/the_body_as_home'
  t.tag '@user/the_body_as_home'
  t.tag '@user/overcoming_trauma_through_yoga'
  t.tag '@guest/gothic_architecture'
  t.tag '@user/gothic_architecture'
  t.tag '@guest/el_croquis'
  t.tag '@user/el_croquis'
  t.tag '@guest/book'
  t.tag '@guest/journal'
  t.tag '@guest/checked_out'
  t.tag '@user/checked_out'
  t.tag '@consortium_user/checked_out'
  t.tag '@guest/requested'
  t.tag '@user/requested'
  t.tag '@guest/recalled'
  t.tag '@user/recalled'
  t.tag '@guest/processing'
  t.tag '@user/processing'
  t.tag '@guest/on_order'
  t.tag '@user/on_order'
  t.tag '@guest/offsite'
  t.tag '@user/offsite'
  t.tag '@guest/available'
  t.tag '@user/available'
  t.tag '@guest/ill'
  t.tag '@user/ill'
  t.tag '@logout'
  # Disallowed not in use
  t.tags '@disallowed', record: :none
end
