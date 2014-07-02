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
  t.tag  '@new_yorker', record: :new_episodes
  t.tag  '@vogue', record: :new_episodes
  t.tag  '@book'
  t.tag  '@journal', record: :new_episodes
  t.tag  '@checked_out'
  t.tag  '@requested'
  t.tag  '@recalled'
  t.tag  '@processing'
  t.tag  '@on_order'
  t.tag  '@offsite'
  t.tag  '@available'
  t.tag  '@ill'
  # Disallowed not in use
  t.tags '@disallowed', record: :none
end
