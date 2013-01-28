require 'test_helper'

class RequestsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  test "requests source data test" do
    UserSession.create(users(:std5))
    assert_nil(@controller.adm_library_code)
    assert_nil(@controller.sub_library_code)
    assert_nil(@controller.source_record_id)
    assert_nil(@controller.item_id)
    assert_nil(@controller.item_status_code)
    assert_nil(@controller.item_process_status_code)
    assert_nil(@controller.circulation_status)
    assert_nil(@controller.illiad_url)
    assert_nil(@controller.aleph_rest_url)
    assert_nil(@controller.ill_url)
    assert_nil(@controller.scan?)
    assert_nil(@controller.pickup_location)
    assert_nil(@controller.request_type)
    VCR.use_cassette('requests source data test') do
      get(:new, {'service_response_id' => "1"})
      assert_response :success
      assert_equal("NYU50", @controller.adm_library_code)
      assert_equal("BOBST", @controller.sub_library_code)
      assert_equal("000980206", @controller.source_record_id)
      assert_equal("NYU50000980206000010", @controller.item_id)
      assert_equal("01", @controller.item_status_code)
      assert_nil(@controller.item_process_status_code)
      assert_equal("On Shelf", @controller.circulation_status)
      assert_equal("http://ill.library.nyu.edu", @controller.illiad_url)
      assert_equal("http://aleph.library.nyu.edu:1891/rest-dlf", @controller.aleph_rest_url)
      assert((not @controller.ill_url.nil?))
      assert_nil(@controller.scan?)
      assert_nil(@controller.pickup_location)
      assert_nil(@controller.request_type)
    end
  end

  test "requests request types" do
    assert_equal(["available", "ill", "in_processing", "offsite", "on_order", "recall"],
      @controller.request_types)
  end

  test "requests request attributes" do
    assert_equal([:status, :status_code, :adm_library_code, :sub_library, :sub_library_code,
      :source_record_id, :item_id, :item_status_code, :item_process_status_code,
        :circulation_status], @controller.send(:request_attributes))
  end

  test "requests item permissions" do
    UserSession.create(users(:std5))
    VCR.use_cassette('requests item permissions') do
      get(:new, {'service_response_id' => "1"})
      @controller.send(:init)
      assert((not @controller.send(:item_permissions).nil?))
      assert((not @controller.send(:item_permissions).empty?))
    end
  end

  test "requests item requestability" do
    UserSession.create(users(:std5))
    VCR.use_cassette('requests item requestability') do
      get(:new, {'service_response_id' => "1"})
      @controller.send(:init)
      assert_equal(RequestsHelper::RequestableDeferred, @controller.send(:item_requestability))
    end
  end

  test "requests item requestable" do
    UserSession.create(users(:std5))
    VCR.use_cassette('requests item requestable') do
      get(:new, {'service_response_id' => "1"})
      @controller.send(:init)
      assert(@controller.send(:item_requestable?))
    end
  end

  test "user permissions" do
    UserSession.create(users(:std5))
    VCR.use_cassette('requests user permissions') do
      get(:new, {'service_response_id' => "1"})
      assert((not @controller.send(:user_permissions).nil?))
      assert((not @controller.send(:user_permissions).empty?))
    end
  end

  test "requests new request" do
    UserSession.create(users(:std5))
    VCR.use_cassette('requests new request') do
      get(:new, {'service_response_id' => "1"})
      assert @controller.request?, "Not requestable."
    end
  end

  test "requests new request available" do
    UserSession.create(users(:std5))
    VCR.use_cassette('requests request available') do
      get(:new, {'service_response_id' => "1"})
      assert @controller.request_available?, "Not requestable available."
      assert((not @controller.request_recall?), "Recall requestable.")
      assert((not @controller.request_in_processing?), "In processing requestable.")
      assert((not @controller.request_on_order?), "On order requestable.")
      assert((not @controller.request_offsite?), "Offsite requestable.")
      assert((not @controller.request_ill?), "ILL requestable.")
    end
  end

  test "requests layout" do
    UserSession.create(users(:std5))
    VCR.use_cassette('requests layout') do
      get(:new, :service_response_id => 1)
      assert_response :success
      assert_select "body div.nyu-container", 1
      assert_select "div.request", 1
    end
  end

  test "requests layout xhr" do
    UserSession.create(users(:std5))
    VCR.use_cassette('requests layout xhr') do
      xhr :get, :new, :service_response_id => 1
      assert_response :success
      # Assert that no layout was included in the request
      assert_select "body", 0
      assert_select "div.nyu-container", 0
      assert_select "div.request", 1
    end
  end

  test "requests routes" do
    assert_equal "http://test.host/requests/1/ill/BOBST", create_request_url(1, "ill", "BOBST")
    assert_equal "http://test.host/requests/1/on_order", create_request_url(1, "on_order")
    assert_equal "http://test.host/requests/1/recall", create_request_url(1, "recall")
    assert_equal "http://test.host/requests/1/in_processing", create_request_url(1, "in_processing")
    assert_equal "http://test.host/requests/1/available", create_request_url(1, "available")
  end

  test "requests not logged in" do
    VCR.use_cassette('requests not logged in') do
      get(:new, {'service_response_id' => "1"})
      assert_response :unauthorized
    end
  end

  test "requests new available" do
    UserSession.create(users(:std5))
    VCR.use_cassette('requests new available') do
      get(:new, {'service_response_id' => "1"})
      assert_response :success
      assert_select 'div.request' do
        assert_select 'h2', {:count => 1,
          :text => "Virtual inequality : beyond the digital divide is available at NYU Bobst."},
            "Unexpected h2 text."
        assert_select 'ol.request_options li', 2
        assert_select 'form.request_available input[name="request_type"]', {:count => 1, :value => "available"}
      end
    end
  end

  test "requests new offsite" do
    UserSession.create(users(:std5))
    VCR.use_cassette('requests new offsite') do
      get(:new, {'service_response_id' => "3"})
      assert_response :success
      assert_select 'div.request' do |elements|
        assert_select 'h2', {:count => 1,
          :text => "Virtual inequality : beyond the digital divide is available from the New School Fogelman Library offsite storage facility."},
            "Unexpected h2 text."
        assert_select 'ol.request_options li', 2
        assert_select 'form.request_offsite input[name="request_type"]', {:count => 1, :value => "offsite"}
      end
    end
  end

  test "requests new recall" do
    UserSession.create(users(:std5))
    VCR.use_cassette('requests new recall') do
      get(:new, {'service_response_id' => "4"})
      assert_response :success
      assert_select 'div.request' do |elements|
        assert_select 'h2', {:count => 1,
          :text => "Programming Ruby : the pragmatic programmers&#x27; guide is checked out."},
            "Unexpected h2 text."
        assert_select 'ol.request_options li', 2
        assert_select 'form.request_recall input[name="request_type"]', {:count => 1, :value => "recall"}
      end
    end
  end

  test "requests new in processing" do
    UserSession.create(users(:std5))
    VCR.use_cassette('requests new in processing') do
      get(:new, {:service_response_id => 5})
      assert_response :success
      assert_select 'div.request' do |elements|
        assert_select 'h2', {:count => 1,
          :text => "Programming Ruby : the pragmatic programmers&#x27; guide is currently being processed by library staff."},
            "Unexpected h2 text."
        assert_select 'ol.request_options li', 2
        assert_select 'form.request_in_processing input[name="request_type"]', {:count => 1, :value => "in_processing"}
      end
    end
  end

  test "requests create available journal" do
    UserSession.create(users(:std5))
    VCR.use_cassette('requests create available journal') do
      get(:create, {:service_response_id => 2, :request_type => "available"})
      assert_response :unauthorized
    end
  end

  test "requests create nonexistent type" do
    UserSession.create(users(:std5))
    VCR.use_cassette('requests create available journal') do
      get(:create, {:service_response_id => 2, :request_type => "nonexistent"})
      assert_response :bad_request
    end
  end

  test "requests create aleph error" do
    UserSession.create(users(:std5))
    VCR.use_cassette('requests create aleph error') do
      get(:create, {:service_response_id => 1, :request_type => "available"})
      assert_response :redirect
      assert_redirected_to "http://test.host/requests/new/1"
      assert_equal "Failed to create request: Patron has already requested this item.", flash[:alert]
    end
  end
  
  test "requests create available" do
    UserSession.create(users(:std5))
    VCR.use_cassette('requests create available') do
      get(:create, {:service_response_id => 1, :request_type => "available"})
      assert_response :redirect
      assert_redirected_to "http://test.host/requests/1?pickup_location=BOBST&scan=false"
    end
    get(:show, {:service_response_id => 1, :pickup_location => "BOBST", :scan => false})
    assert_select("div.text-success", {:count => 1, 
      :text => "Your scan request has been processed. You will receive an email when the item is available."})
  end
  
  test "requests create offsite" do
    UserSession.create(users(:std5))
    VCR.use_cassette('requests create offsite') do
      get(:create, {:service_response_id => 3, :request_type => "offsite"})
      assert_response :redirect
      assert_redirected_to "http://test.host/requests/3?pickup_location=TNSFO&scan=false"
    end
    get(:show, {:service_response_id => 3, :pickup_location => "TNSFO", :scan => false})
    assert_select("div.text-success", {:count => 1, 
      :text => "Your scan request has been processed. You will receive an email when the item is available."})
  end
  
  test "requests create recall" do
    UserSession.create(users(:std5))
    VCR.use_cassette('requests create recall') do
      get(:create, {:service_response_id => 4, :request_type => "recall"})
      assert_response :redirect
      assert_redirected_to "http://test.host/requests/4?pickup_location=NCOUR&scan=false"
    end
    get(:show, {:service_response_id => 4, :pickup_location => "NCOUR", :scan => false})
    assert_select("div.text-success", {:count => 1, 
      :text => "Your scan request has been processed. You will receive an email when the item is available."})
  end
  
  test "requests create in processing" do
    UserSession.create(users(:std5))
    VCR.use_cassette('requests create in processing') do
      get(:create, {:service_response_id => 5, :request_type => "in_processing"})
      assert_response :redirect
      assert_redirected_to "http://test.host/requests/5?pickup_location=NABUD&scan=false"
    end
    get(:show, {:service_response_id => 5, :pickup_location => "NABUD", :scan => false})
    assert_select("div.text-success", {:count => 1, 
      :text => "Your scan request has been processed. You will receive an email when the item is available."})
  end

  test "requests create ill" do
    UserSession.create(users(:std5))
    get(:create, {:service_response_id => 5, :request_type => "ill"})
    assert_response :redirect
    assert @response.location.starts_with?("http://ill.library.nyu.edu/illiad/illiad.dll/OpenURL?url_ver=Z39.88-2004&url_ctx_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Actx&ctx_ver=Z39.88-2004&")
  end
end