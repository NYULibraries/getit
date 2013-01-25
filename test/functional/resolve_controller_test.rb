require 'test_helper'

class ResolveControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  test "resolve request available logged in" do
    UserSession.create(users(:std5))
    umlaut_request = requests(:primo_book_virtual_inequality)
    VCR.use_cassette('resolve request available logged in') do
      get(:index, {'umlaut.request_id' => umlaut_request.id})
      assert_response :success
      assert_select 'div.umlaut-holdings div.umlaut-holding ' do |elements|
        elements.each do |element|
          assert_select element, "a.ajax_window", {:count => 1, :text => "Request"}
        end
      end
    end
  end

  test "resolve request available not logged in" do
    umlaut_request = requests(:primo_book_virtual_inequality)
    VCR.use_cassette('resolve request available not logged in') do
      get(:index, {'umlaut.request_id' => umlaut_request.id})
      assert_response :success
      assert_select 'div.umlaut-holdings div.umlaut-holding ' do |elements|
        elements.each do |element|
          assert_select element, "a.ajax_window", {:count => 0}
        end
      end
    end
  end
end