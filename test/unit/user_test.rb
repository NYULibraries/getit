require 'test_helper'
class UserTest < ActiveSupport::TestCase
  test "aleph permissions by sub library code" do
    user = users(:uid)
    assert_nil(user.user_attributes[:aleph_permissions], "User attributes Aleph permissions not nil at start")
    assert_equal({}, user.send(:aleph_permissions), "Aleph permissions not empty at start")
    VCR.use_cassette('user aleph permissions') do
      nyu50_bobst_permissions = user.aleph_permissions_by_sub_library_code("NYU50", "BOBST")
      assert((not nyu50_bobst_permissions.nil?))
      assert((not nyu50_bobst_permissions.empty?))
    end
  end
end
