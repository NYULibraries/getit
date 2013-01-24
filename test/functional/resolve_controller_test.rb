require 'test_helper'

class ResolveControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  test "request available" do
    UserSession.create(users(:std5))
    request = requests(:primo_book_virtual_inequality)
    get(:index, {'umlaut.request_id' => request.id})
    assert_response :success
    assert_select 'div.umlaut-holdings div.umlaut-holding ' do |elements|
      elements.each do |element|
        assert_select element, "a.ajax_window", {:count => 1, :text => "Request"}
      end
    end
  end

  test "no logged in user" do
    request = requests(:primo_book_virtual_inequality)
    get(:index, {'umlaut.request_id' => request.id})
    assert_response :success
    assert_select 'div.umlaut-holdings div.umlaut-holding ' do |elements|
      elements.each do |element|
        assert_select element, "a.ajax_window", {:count => 0}
      end
    end
  end
end