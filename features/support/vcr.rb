require 'vcr'

VCR.config do |c|
  c.stub_with :webmock
  c.ignore_hosts '127.0.0.1', 'localhost'
  c.cassette_library_dir     = 'features/cassettes'
  c.default_cassette_options = { 
    record: :new_episodes,
    match_requests_on: [:method, VCR.request_matchers.uri_without_param(:ctx_tim)]
  }
end

VCR.cucumber_tags do |t|
  # Uses default record mode since no options are given
  t.tag  '@checked_out_item'
  t.tag  '@requested_item'
  t.tag  '@offsite_item'
  t.tag  '@available_item'
  t.tag  '@recalled_item'
  t.tag  '@ill_item'
  # Disallowed not in use
  t.tags '@disallowed', :record => :none
end
