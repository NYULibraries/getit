# encoding: UTF-8
require 'test_helper'

class ResolveControllerTest < ActionController::TestCase
  setup do
    activate_authlogic
    # Pretend we've already checked PDS/Shibboleth for the session
    # and we have a session
    @controller.session[:attempted_sso] = true
    @controller.session[:session_id] = "FakeSessionID"
  end

  test "url for request" do
    umlaut_request = requests(:frankenstein)
    assert_equal "http://test.host/resolve?"+
        "umlaut.request_id=#{umlaut_request.id}",
          @controller.url_for_request(umlaut_request)
  end

  test "resolve request available logged in" do
    UserSession.create(users(:uid))
    umlaut_request = requests(:primo_book_virtual_inequality)
    VCR.use_cassette('resolve request available logged in') do
      get(:index, {'umlaut.request_id' => umlaut_request.id})
      assert_response :success
      assert_select 'nav#nav1 div.umlaut-permalink', 1
      assert_select 'nav#nav1 div.umlaut-permalink a',
        {:count => 1, :text => "http://test.host/go/#{umlaut_request.id}"}
      assert_select 'nav#nav1 i.icons-famfamfam-lock', 1
      assert_select 'nav#nav1 a.logout', {:count => 1, :text => "Log-out Given Name", :href => "http://test.host/logout"}
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
      assert_select 'nav#nav1 div.umlaut-permalink', 1
      assert_select 'nav#nav1 div.umlaut-permalink a',
        {:count => 1, :text => "http://test.host/go/#{umlaut_request.id}"}
      assert_select 'nav#nav1 i.icons-famfamfam-lock_open', 1
      assert_select 'nav#nav1 a.login', {:count => 1, :text => "Login",
        :href => "http://test.host/login?return_url=http://test.host/go/#{umlaut_request.referent.id}&umlaut.institution=NYU"}
      assert_select 'div.umlaut-holdings div.umlaut-holding ' do |elements|
        elements.each do |element|
          assert_select element, "a.ajax_window", {:count => 0}
        end
      end
    end
  end

  test "resolve request available logged in but no on shelf permission" do
    UserSession.create(users(:uid))
    umlaut_request = requests(:primo_book_chemistry_the_molecular_nature_of_matter_and_change)
    VCR.use_cassette('resolve request available logged in but no on shelf permission') do
      get(:index, {'umlaut.request_id' => umlaut_request.id})
      assert_response :success
      assert_select 'nav#nav1 i.icons-famfamfam-lock', 1
      assert_select 'nav#nav1 a.logout', {:count => 1, :text => "Log-out Given Name", :href => "http://test.host/logout"}
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
      assert_select 'nav#nav1 div.umlaut-permalink', 1
      assert_select 'nav#nav1 div.umlaut-permalink a', { count: 1,
        :text => "http://test.host/go/#{umlaut_request.id}?umlaut.institution=NS",
          :href => "http://test.host/go/#{umlaut_request.referent.id}?umlaut.institution=NS"}
      assert_select 'nav#nav1 i.icons-famfamfam-lock_open', 1
      assert_select 'nav#nav1 a.login', {:count => 1, :text => "Login",
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
      assert_select 'nav#nav1 div.umlaut-permalink', 1
      assert_select 'nav#nav1 div.umlaut-permalink a', { count: 1,
        :text => "http://test.host/go/#{umlaut_request.id}?umlaut.institution=CU",
          :href => "http://test.host/go/#{umlaut_request.referent.id}?umlaut.institution=CU"}
      assert_select 'nav#nav1 i.icons-famfamfam-lock_open', 1
      assert_select 'nav#nav1 a.login', {:count => 1, :text => "Login",
        :href => "http://test.host/login?return_url=http://test.host/go/#{umlaut_request.referent.id}&umlaut.institution=CU"}
      assert_select 'div.umlaut-holdings div.umlaut-holding ' do |elements|
        elements.each do |element|
          assert_select element, "a.ajax_window", {:count => 0}
        end
      end
    end
  end

  test "resolve IA fulltext not logged in" do
    umlaut_request = requests(:momo)
    VCR.use_cassette('resolve IA fulltext not logged in') do
      get(:index, {'umlaut.request_id' => umlaut_request.id})
      assert_response :success
      assert_select 'nav#nav1 i.icons-famfamfam-lock_open', 1
      assert_select 'nav#nav1 a.login', {:count => 1, :text => "Login",
        :href => "http://test.host/login?return_url=http://test.host/go/#{umlaut_request.referent.id}"}
      assert_select 'div#fulltext ul.response_list li.response_item' do |elements|
        assert_equal(1, elements.size)
        elements.each do |element|
          assert_select element, "a", {:count => 1, :href => "", :text => "the Internet Archive: Open Source Book"}
          assert_select element, 'div.edition_warning', {:count => 1,
            :text => "Edition information Momo, ovvero l&#x27;arcana storia dei ladri di tempo e della bambina che restituÃ¬ agli uomini il tempo trafugato"}
        end
      end
    end
  end

  test "resolve no holdings not logged in" do
    umlaut_request = requests(:advocate)
    VCR.use_cassette('resolve no holdings not logged in') do
      get(:index, {'umlaut.request_id' => umlaut_request.id, "umlaut.institution" => "NYU"})
      assert_response :success
      assert_select 'nav#nav1 i.icons-famfamfam-lock_open', 1
      assert_select 'nav#nav1 a.login', {:count => 1, :text => "Login",
        :href => "http://test.host/login?return_url=http://test.host/go/#{umlaut_request.referent.id}&umlaut.institution=CU"}
      assert_select 'div#fulltext ul.response_list li.response_item' do |elements|
        assert_equal(1, elements.size)
        elements.each do |element|
          assert_select element, "a", {:count => 1, :href => "", :text => "Gale Cengage Newsstand"}
          assert_select element, 'div.response_coverage_statement', {:count => 1, :text => "Available from 2009."}
        end
      end
      # Assert no holdings
      assert_select 'div#holding div.umlaut-holdings', :count => 0
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

  test "default institutions with no user" do
    institutions = @controller.send(:institutions, nil)
    assert_equal(2, institutions.length)
    assert_equal(:default, institutions.first.code)
    assert_equal(:NYU, institutions.last.code)
  end

  test "default institutions with NYU user" do
    UserSession.create(users(:uid))
    institutions = @controller.send(:institutions, nil)
    assert_equal(2, institutions.length)
    assert_equal(:default, institutions.first.code)
    assert_equal(:NYU, institutions.last.code)
  end

  test "NYU user insitution" do
    UserSession.create(users(:uid))
    institutions = @controller.send(:user_institutions)
    assert_equal(1, institutions.length)
    assert_equal(:NYU, institutions.first.code)
  end

  test "NS institutions with no user" do
    # The cookies get munged in the test
    institutions = @controller.send(:institutions, "NS")
    assert_equal(2, institutions.length)
    assert_equal(:default, institutions.first.code)
    assert_equal(:NS, institutions.last.code)
  end

  test "NS institutions with NYU user" do
    UserSession.create(users(:uid))
    institutions = @controller.send(:institutions, "NS")
    assert_equal(3, institutions.length)
    assert_equal(:default, institutions.first.code)
    assert_equal(:NS, institutions[1].code)
    assert_equal(:NYU, institutions.last.code)
  end

  test "NS institutions with NS user" do
    UserSession.create(users(:nsUser))
    institutions = @controller.send(:institutions, "NS")
    assert_equal(2, institutions.length)
    assert_equal(:default, institutions.first.code)
    assert_equal(:NS, institutions.last.code)
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
