require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  test "should redirect to login page" do
    get :new
    assert_response :redirect
    assert_redirected_to "https://logindev.library.nyu.edu/pds?func=load-login&institute=NYU&calling_system=umlaut&url=http%3A%2F%2Ftest.host%2Fvalidate%3Freturn_url%3Dhttp%253A%252F%252Ftest.host%252F%26umlaut_controller%3Duser_sessions%26umlaut_action%3Dnew", "Redirected to incorrect URL."
  end
end