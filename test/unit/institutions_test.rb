require 'test_helper'
class InstitutionsTest < ActiveSupport::TestCase
  test "ip addresses" do
    ips = Institutions.institutions[:NYU].ip_addresses
    assert_not_nil(ips) if ENV.has_key?('INSTITUTIONS')
  end
end