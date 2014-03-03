require 'test_helper'
class UserSessionTest < ActiveSupport::TestCase
  setup :activate_authlogic

  test "expiration date" do
    user = users(:uid)
    VCR.use_cassette('user session additional attributes') do
      user_session = UserSession.create(user)
      user.refreshed_at = Time.now
      user.expiration_date = user_session.expiration_date
      assert(!user.expired?, "User is expired when created")
      user.refreshed_at = DateTime.now - 1.day
      assert(user.expired?, "User is not expired after 1 day")
    end
  end

  test "user session additional attributes" do
    user = users(:uid)
    assert_nil(user.user_attributes[:aleph_permissions], "Aleph permissions not nil at start")
    assert(user.expired?, "User not expired")
    VCR.use_cassette('user session additional attributes') do
      user_session = UserSession.create(user)
      user.user_attributes = user_session.additional_attributes
      user.refreshed_at = Time.now
      user.expiration_date = user_session.expiration_date
      assert((not user.user_attributes[:aleph_permissions].nil?), "Aleph permissions nil after user session additional_attributes is called.")
      assert((not user.user_attributes[:aleph_permissions]["BOBST"].nil?), "Bobst permissions nil after user session additional_attributes is called.")
      assert_equal("Y", user.user_attributes[:aleph_permissions]["BOBST"][:hold_permission], "Hold permission not 'Y'")
      assert((not user_session.nil?))
      user_session.destroy
      assert_nil(user_session.record)
    end
    assert((not user.expired?), "User expired after user session is created")
    assert((not user.user_attributes[:aleph_permissions].nil?), "Aleph permissions nil after user session is destroyed.")
    assert((not user.user_attributes[:aleph_permissions]["BOBST"].nil?), "Bobst permissions nil after user session is destroyed.")
    assert_equal("Y", user.user_attributes[:aleph_permissions]["BOBST"][:hold_permission], "Hold permission not 'Y' after user session is destroyed")
    user_session = UserSession.create(user)
    # Assert no VCR exception is raised
    # since we shouldn't be making an HTTP call.
    assert_nothing_raised {
      user.user_attributes = user_session.additional_attributes
    }
    assert((not user.user_attributes[:aleph_permissions].nil?), "Aleph permissions nil after user session is created.")
    assert((not user.user_attributes[:aleph_permissions]["BOBST"].nil?), "Bobst permissions nil after user session is created.")
    assert_equal("Y", user.user_attributes[:aleph_permissions]["BOBST"][:hold_permission], "Hold permission not 'Y'")
  end
end
