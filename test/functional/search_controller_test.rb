require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  setup :activate_authlogic

  test "search index logged in" do
    UserSession.create(users(:std5))
    get :index
    assert_response :success
    assert_select "title", "BobCat"
    assert_select 'div.search div.search-section', 3
  end

  test "index not logged in" do
    # Need to wrap since there is a check for the OpenSSO cookie name.
    VCR.use_cassette('search index logged in') do
      get :index
      assert_response :success
      assert_select "title", "BobCat"
      assert_select 'div.search div.search-section', 3
    end
  end

  test "journal search logged in" do
    UserSession.create(users(:std5))
    VCR.use_cassette('search journal search logged in') do
      get :journal_search, "rft.jtitle"=>"New York", "umlaut.title_search_type"=>"contains"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select 'div.search div.search-section', 2
      assert_select 'div.nyu-pagination', 2
      assert_select 'div.results div.result', 20
    end
  end

  test "journal search not logged in" do
    VCR.use_cassette('search journal search not logged in') do
      get :journal_search, "rft.jtitle"=>"New York", "umlaut.title_search_type"=>"contains"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select 'div.search div.search-section', 2
      assert_select 'div.nyu-pagination', 2
      assert_select 'div.results div.result', 20
    end
  end

  test "journal list logged in" do
    UserSession.create(users(:std5))
    VCR.use_cassette('search journal list logged in') do
      get :journal_list, :id => "A"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select 'div.search div.search-section', 2
      assert_select 'div.nyu-pagination', 2
      assert_select 'div.results div.result', 20
    end
  end

  test "journal list not logged in" do
    VCR.use_cassette('search journal list not logged in') do
      get :journal_list, :id => "A"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select 'div.search div.search-section', 2
      assert_select 'div.nyu-pagination', 2
      assert_select 'div.results div.result', 20
    end
  end
end