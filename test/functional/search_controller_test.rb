require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  setup :activate_authlogic

  test "index logged in" do
    UserSession.create(users(:std5))
    get :index
    assert_response :success
    assert_select "title", "BobCat"
    assert_select 'div.search div.search-section', 3
  end

  test "index not logged in" do
    request = requests(:primo_book_virtual_inequality)
    get :index
    assert_response :success
    assert_select "title", "BobCat"
    assert_select 'div.search div.search-section', 3
  end

  test "journal search logged in" do
    UserSession.create(users(:std5))
    get :journal_search, "rft.jtitle"=>"New York", "umlaut.title_search_type"=>"contains"
    assert_response :success
    assert_select "title", "BobCat"
    assert_select 'div.search div.search-section', 2
    assert_select 'div.nyu-pagination', 2
    assert_select 'div.results div.result', 20
  end

  test "journal search not logged in" do
    request = requests(:primo_book_virtual_inequality)
    get :journal_search, "rft.jtitle"=>"New York", "umlaut.title_search_type"=>"contains"
    assert_response :success
    assert_select "title", "BobCat"
    assert_select 'div.search div.search-section', 2
    assert_select 'div.nyu-pagination', 2
    assert_select 'div.results div.result', 20
  end

  test "journal list logged in" do
    UserSession.create(users(:std5))
    get :journal_list, :id => "A"
    assert_response :success
    assert_select "title", "BobCat"
    assert_select 'div.search div.search-section', 2
    assert_select 'div.nyu-pagination', 2
    assert_select 'div.results div.result', 20
  end

  test "journal list not logged in" do
    UserSession.create(users(:std5))
    get :journal_list, :id => "A"
    assert_response :success
    assert_select "title", "BobCat"
    assert_select 'div.search div.search-section', 2
    assert_select 'div.nyu-pagination', 2
    assert_select 'div.results div.result', 20
  end
end