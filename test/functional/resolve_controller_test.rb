require 'test_helper'

class ResolveControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  test "resolve request available logged in" do
    UserSession.create(users(:std5))
    umlaut_request = requests(:primo_book_virtual_inequality)
    VCR.use_cassette('resolve request available logged in') do
      get(:index, {'umlaut.request_id' => umlaut_request.id})
      assert_response :success
      assert_select 'nav.umlaut-resolve-nav div#permalink span', {:count => 1, :text => "URL:"}
      assert_select 'nav.umlaut-resolve-nav div#permalink a', 
        {:count => 1, :text => "http://test.host/go/#{umlaut_request.id}"}
      assert_select 'nav.umlaut-resolve-nav i.icons-famfamfam-lock', 1
      assert_select 'nav.umlaut-resolve-nav a.logout', {:count => 1, :text => "Log-out Scot Thomas", :href => "http://test.host/logout"}
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
      assert_select 'nav.umlaut-resolve-nav div#permalink span', {:count => 1, :text => "URL:"}
      assert_select 'nav.umlaut-resolve-nav div#permalink a', {:count => 1, 
        :text => "http://test.host/go/#{umlaut_request.id}", :href => "http://test.host/go/#{umlaut_request.referent.id}"}
      assert_select 'nav.umlaut-resolve-nav i.icons-famfamfam-lock_open', 1
      assert_select 'nav.umlaut-resolve-nav a.login', {:count => 1, :text => "Login", 
        :href => "http://test.host/login?return_url=http://test.host/go/#{umlaut_request.referent.id}&umlaut.institution=NYU"}
      assert_select 'div.umlaut-holdings div.umlaut-holding ' do |elements|
        elements.each do |element|
          assert_select element, "a.ajax_window", {:count => 0}
        end
      end
    end
  end
end