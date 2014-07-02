require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  test "should redirect to login page" do
    get :new
    assert_response :redirect
    assert_redirected_to "#{ENV['PDS_URL']}/pds?func=load-login&institute=NYU&calling_system=getit&url=http%3A%2F%2Ftest.host%2Fvalidate%3Freturn_url%3Dhttp%253A%252F%252Ftest.host%252F%26getit_controller%3Duser_sessions%26getit_action%3Dnew", "Redirected to incorrect URL."
  end
end
