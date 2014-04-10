require 'vcr'

VCR.configure do |c|
  c.stub_with :webmock
  c.ignore_hosts '127.0.0.1', 'localhost'
  c.cassette_library_dir     = 'features/cassettes'
  c.default_cassette_options = { 
    # record: :new_episodes,
    match_requests_on: [:method, VCR.request_matchers.uri_without_param(:ctx_tim)]
  }
end

VCR.cucumber_tags do |t|
  # Uses default record mode since no options are given
  t.tag  '@checked_out'
  t.tag  '@requested'
  t.tag  '@offsite'
  t.tag  '@available'
  t.tag  '@recalled'
  t.tag  '@ill'
  # Disallowed not in use
  t.tags '@disallowed', :record => :none
end
