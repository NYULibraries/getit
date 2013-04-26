require 'test_helper'
class InstitutionsTest < ActiveSupport::TestCase
  test "ip addresses" do
    ips =  Institutions.institutions[:NYU].ip_addresses
    assert_not_nil ips
    assert_not_nil Settings.institutions.NYU.ip_addresses
    assert_not_empty Settings.institutions.NYU.ip_addresses
    Settings.institutions.each do |key, values|
      next if key.eql? :default
      ips = Institutions.institutions[key].ip_addresses
      values.ip_addresses.each do |ip|
        assert_not_nil ip
        assert ips.include? ip.gsub("*", "255").split("-").first
      end
    end
  end
end