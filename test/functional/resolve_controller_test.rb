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
        :text => "http://test.host/go/#{umlaut_request.id}", 
          :href => "http://test.host/go/#{umlaut_request.referent.id}"}
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

  test "resolve request available not logged in NS" do
    umlaut_request = requests(:primo_book_virtual_inequality)
    VCR.use_cassette('resolve request available not logged in NS') do
      get(:index, {'umlaut.request_id' => umlaut_request.id, "umlaut.institution" => "NS"})
      assert_response :success
      assert_select 'nav.umlaut-resolve-nav div#permalink span', {:count => 1, :text => "URL:"}
      assert_select 'nav.umlaut-resolve-nav div#permalink a', {:count => 1, 
        :text => "http://test.host/go/#{umlaut_request.id}?umlaut.institution=NS", 
          :href => "http://test.host/go/#{umlaut_request.referent.id}?umlaut.institution=NS"}
      assert_select 'nav.umlaut-resolve-nav i.icons-famfamfam-lock_open', 1
      assert_select 'nav.umlaut-resolve-nav a.login', {:count => 1, :text => "Login", 
        :href => "http://test.host/login?return_url=http://test.host/go/#{umlaut_request.referent.id}&umlaut.institution=NS"}
      assert_select 'div.umlaut-holdings div.umlaut-holding ' do |elements|
        elements.each do |element|
          assert_select element, "a.ajax_window", {:count => 0}
        end
      end
    end
  end

  test "resolve request available not logged in CU" do
    umlaut_request = requests(:primo_book_virtual_inequality)
    VCR.use_cassette('resolve request available not logged in CU') do
      get(:index, {'umlaut.request_id' => umlaut_request.id, "umlaut.institution" => "CU"})
      assert_response :success
      assert_select 'nav.umlaut-resolve-nav div#permalink span', {:count => 1, :text => "URL:"}
      assert_select 'nav.umlaut-resolve-nav div#permalink a', {:count => 1, 
        :text => "http://test.host/go/#{umlaut_request.id}?umlaut.institution=CU", 
          :href => "http://test.host/go/#{umlaut_request.referent.id}?umlaut.institution=CU"}
      assert_select 'nav.umlaut-resolve-nav i.icons-famfamfam-lock_open', 1
      assert_select 'nav.umlaut-resolve-nav a.login', {:count => 1, :text => "Login", 
        :href => "http://test.host/login?return_url=http://test.host/go/#{umlaut_request.referent.id}&umlaut.institution=CU"}
      assert_select 'div.umlaut-holdings div.umlaut-holding ' do |elements|
        elements.each do |element|
          assert_select element, "a.ajax_window", {:count => 0}
        end
      end
    end
  end

  test "get services" do
    institutions = [Institutions.institutions[:default], Institutions.institutions[:NYU]]
    services = @controller.send(:services, institutions)
    assert(services.has_key? "NYU_Primo")
    assert(services.has_key? "NYU_SFX")
    assert((not services.has_key? "NS_SFX"))
    institutions << Institutions.institutions[:NS]
    services = @controller.send(:services, institutions)
    assert(services.has_key? "NYU_Primo")
    assert(services.has_key? "NYU_SFX")
    assert(services.has_key? "NS_SFX")
  end

  # test "expire old holdings" do
  #   umlaut_request = requests(:primo_book_virtual_inequality)
  #   VCR.use_cassette('expire old holdings') do
  #     get(:index, {'umlaut.request_id' => umlaut_request.id})
  #     service_id = "NYU_Primo_Source"
  #     while umlaut_request.service_type_in_progress?("holding") do
  #       p umlaut_request.dispatched_services.find(:first, :conditions=>{:service_id => service_id}).status
  #       # Wait for services to finish
  #       # so sleep a second and check again
  #       sleep 1
  #     end
  #     assert((not umlaut_request.service_type_in_progress?("holding")), "Holding services are in progress")
  #     assert((not umlaut_request.dispatched_services.find(:all, :conditions => {:service_id => service_id}).empty?),
  #       "Dispatched NYU_Primo_Sources are empty")
  #     holdings = get_service_type('holding')
  #     assert((not holdings.empty?), "Holdings are empty.")
  #     @controller.expire_old_holdings(umlaut_request, holdings)
  #     assert(umlaut_request.dispatched_services.find(:all, :conditions => {:service_id => service_id}).empty?,
  #       "Dispatched NYU_Primo_Sources are not empty after expire_old_holdings")
  #   end
  # end
end