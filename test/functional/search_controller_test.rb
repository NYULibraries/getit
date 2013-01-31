require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  test "search institutional config" do
    # UserSession.create(users(:std5))
    # get :index
    # assert_equal "http://sfx.library.nyu.edu/sfxlcl41?", 
    #   @controller.umlaut_config.sfx.sfx_base_url
    # assert_equal SearchMethods::Sfx4Solr::Local, 
    #   @controller.umlaut_config.search.az_search_method
  end

  test "search institutional config NYU" do
    # UserSession.create(users(:std5))
    # @controller.instance_variable_set(:@current_primary_institution, 
    #   Institutions.institutions[:NYU])
    # get :index
    # assert_equal "http://sfx.library.nyu.edu/sfxlcl41?", 
    #   @controller.umlaut_config.sfx.sfx_base_url
    # assert_equal SearchMethods::Sfx4Solr::Local, 
    #   @controller.umlaut_config.search.az_search_method
  end

  test "search institutional config NS" do
    # UserSession.create(users(:std5))
    # @controller.instance_variable_set(:@current_primary_institution, 
    #   Institutions.institutions[:NS])
    # get :index
    # assert_equal "http://sfx4.library.newschool.edu/ns?", 
    #   @controller.umlaut_config.sfx.sfx_base_url
    # assert_equal SearchMethods::Sfx4Solr::Ns, 
    #   @controller.umlaut_config.search.az_search_method
  end

  test "search institutional config CU" do
    # UserSession.create(users(:std5))
    # @controller.instance_variable_set(:@current_primary_institution, 
    #   Institutions.institutions[:CU])
    # get :index
    # assert_equal "http://sfx.library.nyu.edu/sfxcooper?", 
    #   @controller.umlaut_config.sfx.sfx_base_url
    # @controller.class.ancestors
    # assert_equal SearchMethods::Sfx4Solr::Cu, 
    #   @controller.class.ancestors.first
  end

  test "search institutional config NYUAD" do
    # UserSession.create(users(:std5))
    # @controller.instance_variable_set(:@current_primary_institution, 
    #   Institutions.institutions[:NYUAD])
    # get :index
    # assert_equal "http://sfx.library.nyu.edu/sfxlcl41?", 
    #   @controller.umlaut_config.sfx.sfx_base_url
    # assert_equal SearchMethods::Sfx4Solr::Local, 
    #   @controller.umlaut_config.search.az_search_method
  end

  test "search index logged in" do
    UserSession.create(users(:std5))
    get :index
    assert_response :success
    assert_select "title", "BobCat"
    assert_select "head link", {:count => 1, :href => "/assets/search.css"}
    assert_select 'div.search div.search-section', 3
    assert_template :partial => 'nyu/_sidebar', :count => 1
    assert_template :partial => 'nyu/_tip1', :count => 1
    assert_template :partial => 'nyu/_tip2', :count => 1
  end

  test "search index logged in NYU" do
    UserSession.create(users(:std5))
    get :index, "umlaut.institution" => "NYU"
    assert_response :success
    assert_select "title", "BobCat"
    assert_select "head link", {:count => 1, :href => "/assets/search.css"}
    assert_select 'div.search div.search-section', 3
    assert_template :partial => 'nyu/_sidebar', :count => 1
    assert_template :partial => 'nyu/_tip1', :count => 1
    assert_template :partial => 'nyu/_tip2', :count => 1
  end

  test "search index logged in NS" do
    UserSession.create(users(:std5))
    get :index, "umlaut.institution" => "NS"
    assert_response :success
    assert_select "title", "BobCat"
    assert_select "head link", {:count => 1, :href => "/assets/search_ns.css"}
    assert_select 'div.search div.search-section', 3
    assert_template :partial => 'ns/_sidebar', :count => 1
  end

  test "search index logged in CU" do
    UserSession.create(users(:std5))
    get :index, "umlaut.institution" => "CU"
    assert_response :success
    assert_select "title", "BobCat"
    assert_select "head link", {:count => 1, :href => "/assets/search_cu.css"}
    assert_select 'div.search div.search-section', 3
    assert_template :partial => 'cu/_sidebar', :count => 1
  end

  test "search index logged in NYUAD" do
    UserSession.create(users(:std5))
    get :index, "umlaut.institution" => "NYUAD"
    assert_response :success
    assert_select "title", "BobCat"
    assert_select "head link", {:count => 1, :href => "/assets/search_nyuad.css"}
    assert_select 'div.search div.search-section', 3
    assert_template :partial => 'nyuad/_sidebar', :count => 1
    assert_template :partial => 'nyuad/_tip1', :count => 1
  end

  test "index not logged in" do
    # Need to wrap since there is a check for the OpenSSO cookie name.
    VCR.use_cassette('search index not logged in') do
      get :index
      assert_response :success
      assert_select "title", "BobCat"
      assert_select "head link", {:count => 1, :href => "/assets/search.css"}
      assert_select 'div.search div.search-section', 3
      assert_template :partial => 'nyu/_sidebar', :count => 1
      assert_template :partial => 'nyu/_tip1', :count => 1
      assert_template :partial => 'nyu/_tip2', :count => 1
    end
  end

  test "index not logged in NS" do
    # Need to wrap since there is a check for the OpenSSO cookie name.
    VCR.use_cassette('search index not logged in NS') do
      get :index, "umlaut.institution" => "NS"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select "head link", {:count => 1, :href => "/assets/search_ns.css"}
      assert_select 'div.search div.search-section', 3
      assert_template :partial => 'ns/_sidebar', :count => 1
    end
  end

  test "index not logged in CU" do
    # Need to wrap since there is a check for the OpenSSO cookie name.
    VCR.use_cassette('search index not logged in CU') do
      get :index, "umlaut.institution" => "CU"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select "head link", {:count => 1, :href => "/assets/search_cu.css"}
      assert_select 'div.search div.search-section', 3
      assert_template :partial => 'cu/_sidebar', :count => 1
    end
  end

  test "index not logged in NYUAD" do
    # Need to wrap since there is a check for the OpenSSO cookie name.
    VCR.use_cassette('search index not logged in NYUAD') do
      get :index, "umlaut.institution" => "NYUAD"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select "head link", {:count => 1, :href => "/assets/search_nyuad.css"}
      assert_select 'div.search div.search-section', 3
      assert_template :partial => 'nyuad/_sidebar', :count => 1
      assert_template :partial => 'nyuad/_tip1', :count => 1
    end
  end


  test "index not logged in HSL" do
    # Need to wrap since there is a check for the OpenSSO cookie name.
    VCR.use_cassette('search index not logged in HSL') do
      get :index, "umlaut.institution" => "HSL"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select "head link", {:count => 1, :href => "/assets/search_hsl.css"}
      assert_select 'div.search div.search-section', 3
      assert_template :partial => 'hsl/_sidebar', :count => 1
    end
  end

  test "journal search logged in" do
    UserSession.create(users(:std5))
    VCR.use_cassette('search journal search logged in') do
      get :journal_search, "rft.jtitle"=>"New York", "umlaut.title_search_type"=>"contains"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select "head link", {:count => 1, :href => "/assets/search.css"}
      assert_select 'div.search div.search-section', 2
      assert_select 'div.nyu-pagination', 2
      assert_select 'div.results div.result', 20
      assert_template :partial => 'nyu/_sidebar', :count => 1
    end
  end

  test "journal search not logged in" do
    VCR.use_cassette('search journal search not logged in') do
      get :journal_search, "rft.jtitle"=>"New York", "umlaut.title_search_type"=>"contains"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select "head link", {:count => 1, :href => "/assets/search.css"}
      assert_select 'div.search div.search-section', 2
      assert_select 'div.nyu-pagination', 2
      assert_select 'div.results div.result', 20
      assert_template :partial => 'nyu/_sidebar', :count => 1
    end
  end

  test "journal search not logged in NS" do
    VCR.use_cassette('search journal search not logged in NS') do
      get :journal_search, "rft.jtitle"=>"New York", "umlaut.title_search_type"=>"contains", "umlaut.institution" => "NS"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select "head link", {:count => 1, :href => "/assets/search_ns.css"}
      assert_select 'div.search div.search-section', 2
      assert_select 'div.nyu-pagination', 2
      assert_select 'div.results div.result', 20
      assert_template :partial => 'ns/_sidebar', :count => 1
    end
  end

  test "journal search not logged in CU" do
    VCR.use_cassette('search journal search not logged in CU') do
      get :journal_search, "rft.jtitle"=>"New York", "umlaut.title_search_type"=>"contains", "umlaut.institution" => "CU"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select "head link", {:count => 1, :href => "/assets/search_cu.css"}
      assert_select 'div.search div.search-section', 2
      assert_select 'div.nyu-pagination', 2
      assert_select 'div.results div.result', 20
      assert_template :partial => 'cu/_sidebar', :count => 1
    end
  end

  test "journal list logged in" do
    UserSession.create(users(:std5))
    VCR.use_cassette('search journal list logged in') do
      get :journal_list, :id => "A"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select "head link", {:count => 1, :href => "/assets/search.css"}
      assert_select 'div.search div.search-section', 2
      assert_select 'div.nyu-pagination', 2
      assert_select 'div.results div.result', 20
      assert_template :partial => 'nyu/_sidebar', :count => 1
    end
  end

  test "journal list not logged in" do
    VCR.use_cassette('search journal list not logged in') do
      get :journal_list, :id => "A"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select "head link", {:count => 1, :href => "/assets/search.css"}
      assert_select 'div.search div.search-section', 2
      assert_select 'div.nyu-pagination', 2
      assert_select 'div.results div.result', 20
      assert_template :partial => 'nyu/_sidebar', :count => 1
    end
  end

  test "journal list not logged in NS" do
    VCR.use_cassette('search journal list not logged in NS') do
      get :journal_list, :id => "A", "umlaut.institution" => "NS"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select "head link", {:count => 1, :href => "/assets/search_ns.css"}
      assert_select 'div.search div.search-section', 2
      assert_select 'div.nyu-pagination', 2
      assert_select 'div.results div.result', 20
      assert_template :partial => 'ns/_sidebar', :count => 1
    end
  end

  test "journal list not logged in CU" do
    VCR.use_cassette('search journal list not logged in CU') do
      get :journal_list, :id => "A", "umlaut.institution" => "CU"
      assert_response :success
      assert_select "title", "BobCat"
      assert_select "head link", {:count => 1, :href => "/assets/search_cu.css"}
      assert_select 'div.search div.search-section', 2
      assert_select 'div.nyu-pagination', 2
      assert_select 'div.results div.result', 20
      assert_template :partial => 'cu/_sidebar', :count => 1
    end
  end
end