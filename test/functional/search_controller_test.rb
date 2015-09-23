# encoding: UTF-8
require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def user
    FactoryGirl.create(:user)
  end

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "search institutional config" do
    assert @controller.respond_to?(:extend_with_institutional_search_module),
      "Search controller not modified."
  end

  test "search index logged in" do
    sign_in user
    get :index
    assert_response :success
    assert_select "title", "BobCat"
    assert_select 'head link[rel="stylesheet"]', {:count => 1, :href => "/assets/search.css"}
    assert_select 'div.search div.search-section', 3
    assert_tabs_header
    assert_template :partial => 'nyu/_sidebar', :count => 1
    assert_template :partial => 'nyu/_tip1', :count => 1
    assert_template :partial => 'nyu/_tip2', :count => 1
  end

  test "search index logged in NYU" do
    sign_in user
    get :index, "umlaut.institution" => "NYU"
    assert_response :success
    assert_select "title", "BobCat"
    assert_select 'head link[rel="stylesheet"]', {:count => 1, :href => "/assets/search.css"}
    assert_select 'div.search div.search-section', 3
    assert_tabs_header
    assert_template :partial => 'nyu/_sidebar', :count => 1
    assert_template :partial => 'nyu/_tip1', :count => 1
    assert_template :partial => 'nyu/_tip2', :count => 1
  end

  test "search index logged in NS" do
    sign_in user
    get :index, "umlaut.institution" => "NS"
    assert_response :success
    assert_select "title", "BobCat"
    assert_select 'head link[rel="stylesheet"]', {:count => 1, :href => "/assets/search.css"}
    assert_select 'div.search div.search-section', 3
    assert_tabs_header
    assert_template :partial => 'ns/_sidebar', :count => 1
  end

  test "search index logged in CU" do
    sign_in user
    get :index, "umlaut.institution" => "CU"
    assert_response :success
    assert_select "title", "BobCat"
    assert_select 'head link[rel="stylesheet"]', {:count => 1, :href => "/assets/search.css"}
    assert_select 'div.search div.search-section', 3
    assert_tabs_header
    assert_template :partial => 'cu/_sidebar', :count => 1
  end

  test "search index logged in NYUAD" do
    sign_in user
    get :index, "umlaut.institution" => "NYUAD"
    assert_response :success
    assert_select "title", "BobCat"
    assert_select 'head link[rel="stylesheet"]', {:count => 1, :href => "/assets/search.css"}
    assert_select 'div.search div.search-section', 3
    assert_tabs_header
    assert_template :partial => 'nyuad/_sidebar', :count => 1
    assert_template :partial => 'nyuad/_tip1', :count => 1
  end

  test "index not logged in" do
    get :index
    assert_response :success
    assert_select "title", "BobCat"
    assert_select 'head link[rel="stylesheet"]', {:count => 1, :href => "/assets/search.css"}
    assert_select 'div.search div.search-section', 3
    assert_tabs_header
    assert_template :partial => 'nyu/_sidebar', :count => 1
    assert_template :partial => 'nyu/_tip1', :count => 1
    assert_template :partial => 'nyu/_tip2', :count => 1
  end

  test "index not logged in NS" do
    get :index, "umlaut.institution" => "NS"
    assert_response :success
    assert_select "title", "BobCat"
    assert_select 'head link[rel="stylesheet"]', {:count => 1, :href => "/assets/search.css"}
    assert_select 'div.search div.search-section', 3
    assert_tabs_header
    assert_template :partial => 'ns/_sidebar', :count => 1
  end

  test "index not logged in CU" do
    get :index, "umlaut.institution" => "CU"
    assert_response :success
    assert_select "title", "BobCat"
    assert_select 'head link[rel="stylesheet"]', {:count => 1, :href => "/assets/search.css"}
    assert_select 'div.search div.search-section', 3
    assert_tabs_header
    assert_template :partial => 'cu/_sidebar', :count => 1
  end

  test "index not logged in NYUAD" do
    get :index, "umlaut.institution" => "NYUAD"
    assert_response :success
    assert_select "title", "BobCat"
    assert_select 'head link[rel="stylesheet"]', {:count => 1, :href => "/assets/search.css"}
    assert_select 'div.search div.search-section', 3
    assert_tabs_header
    assert_template :partial => 'nyuad/_sidebar', :count => 1
    assert_template :partial => 'nyuad/_tip1', :count => 1
  end


  test "index not logged in HSL" do
    get :index, "umlaut.institution" => "HSL"
    assert_response :success
    assert_select "title", "BobCat"
    assert_select 'head link[rel="stylesheet"]', {:count => 1, :href => "/assets/search.css"}
    assert_select 'div.search div.search-section', 3
    assert_tabs_header
    assert_template :partial => 'hsl/_sidebar', :count => 1
  end

  test "journal search logged in" do
    sign_in user
    VCR.use_cassette('search journal search logged in') do
      get :journal_search, "rft.jtitle"=>"New York", "umlaut.title_search_type"=>"contains"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select 'head link[rel="stylesheet"]', {:count => 1, :href => "/assets/search.css"}
      assert_select 'div.search div.search-section', 2
      assert_select 'div.pagination', 2
      assert_select 'div.results div.result', 20
      assert_tabs_header
      assert_template :partial => 'nyu/_sidebar', :count => 1
    end
  end

  test "journal search not logged in" do
    VCR.use_cassette('search journal search not logged in') do
      get :journal_search, "rft.jtitle"=>"New York", "umlaut.title_search_type"=>"contains"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select 'head link[rel="stylesheet"]', {:count => 1, :href => "/assets/search.css"}
      assert_select 'div.search div.search-section', 2
      assert_select 'div.pagination', 2
      assert_select 'div.results div.result', 20
      assert_tabs_header
      assert_template :partial => 'nyu/_sidebar', :count => 1
    end
  end

  test "journal search not logged in NS" do
    VCR.use_cassette('search journal search not logged in NS') do
      get :journal_search, "rft.jtitle"=>"New York", "umlaut.title_search_type"=>"contains", "umlaut.institution" => "NS"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select 'head link[rel="stylesheet"]', {:count => 1, :href => "/assets/search.css"}
      assert_select 'div.search div.search-section', 2
      assert_select 'div.pagination', 2
      assert_select 'div.results div.result', 20
      assert_tabs_header
      assert_template :partial => 'ns/_sidebar', :count => 1
    end
  end

  test "journal search not logged in CU" do
    VCR.use_cassette('search journal search not logged in CU') do
      get :journal_search, "rft.jtitle"=>"New York", "umlaut.title_search_type"=>"contains", "umlaut.institution" => "CU"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select 'head link[rel="stylesheet"]', {:count => 1, :href => "/assets/search.css"}
      assert_select 'div.search div.search-section', 2
      assert_select 'div.pagination', 2
      assert_select 'div.results div.result', 20
      assert_tabs_header
      assert_template :partial => 'cu/_sidebar', :count => 1
    end
  end

  test "journal list logged in" do
    sign_in user
    VCR.use_cassette('search journal list logged in') do
      get :journal_list, :id => "A"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select 'head link[rel="stylesheet"]', {:count => 1, :href => "/assets/search.css"}
      assert_select 'div.search div.search-section', 2
      assert_select 'div.pagination', 2
      assert_select 'div.results div.result', 20
      assert_tabs_header
      assert_template :partial => 'nyu/_sidebar', :count => 1
    end
  end

  test "journal list not logged in" do
    VCR.use_cassette('search journal list not logged in') do
      get :journal_list, :id => "A"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select 'head link[rel="stylesheet"]', {:count => 1, :href => "/assets/search.css"}
      assert_select 'div.search div.search-section', 2
      assert_select 'div.pagination', 2
      assert_select 'div.results div.result', 20
      assert_tabs_header
      assert_template :partial => 'nyu/_sidebar', :count => 1
      assert_select 'div.results' do |results|
        assert_select results.first, 'div.result h2.title', {:text => 'À bâbord', :count => 1}
      end
    end
  end

  test "journal list not logged in NS" do
    VCR.use_cassette('search journal list not logged in NS') do
      get :journal_list, :id => "A", "umlaut.institution" => "NS"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select 'head link[rel="stylesheet"]', {:count => 1, :href => "/assets/search.css"}
      assert_select 'div.search div.search-section', 2
      assert_select 'div.pagination', 2
      assert_select 'div.results div.result', 20
      assert_tabs_header
      assert_template :partial => 'ns/_sidebar', :count => 1
      assert_select 'div.results' do |results|
        assert_select results.first, 'div.result h2.title', {:text => 'A.A.V. newsletter', :count => 1}
      end
    end
  end

  test "journal list not logged in CU" do
    VCR.use_cassette('search journal list not logged in CU') do
      get :journal_list, :id => "A", "umlaut.institution" => "CU"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select 'head link[rel="stylesheet"]', {:count => 1, :href => "/assets/search.css"}
      assert_select 'div.search div.search-section', 2
      assert_select 'div.pagination', 2
      assert_select 'div.results div.result', 20
      assert_tabs_header
      assert_template :partial => 'cu/_sidebar', :count => 1
      assert_select 'div.results' do |results|
        assert_select results.first, 'div.result h2.title', {:text => 'A+BE :  Architecture and the Built Environment', :count => 1}
      end
    end
  end

  def assert_tabs_header
    assert_select 'nav#bobcat_tabs div.navbar-header h4', {count: 1, text: 'BobCat'}
  end
end
