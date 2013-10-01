require 'test_helper'

class HoldingRequestsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  test "holding requests request types" do
    assert_equal(["available", "ill", "in_processing", "offsite", "on_order", "recall"],
      HoldingRequestsController::WHITELISTED_HOLDING_REQUEST_TYPES)
  end

  test "holding requests new request available" do
    UserSession.create(users(:uid))
    VCR.use_cassette('requests request available') do
      get(:new, {'service_response_id' => "1"})
      authorizer = @controller.instance_variable_get(:@authorizer)
      assert authorizer.available?, "Not requestable available."
      assert((not authorizer.recall?), "Recall requestable.")
      assert((not authorizer.in_processing?), "In processing requestable.")
      assert((not authorizer.on_order?), "On order requestable.")
      assert((not authorizer.offsite?), "Offsite requestable.")
      assert((not authorizer.ill?), "ILL requestable.")
    end
  end

  test "holding requests new request available no on shelf permission" do
    UserSession.create(users(:uid))
    VCR.use_cassette('requests request available no on shelf permission') do
      get(:new, {'service_response_id' => "1"})
      authorizer = @controller.instance_variable_get(:@authorizer)
      assert((not authorizer.available?), "Available requestable.")
      assert((not authorizer.recall?), "Recall requestable.")
      assert((not authorizer.in_processing?), "In processing requestable.")
      assert((not authorizer.on_order?), "On order requestable.")
      assert((not authorizer.offsite?), "Offsite requestable.")
      assert((not authorizer.ill?), "ILL requestable.")
    end
  end

  test "holding requests layout" do
    UserSession.create(users(:uid))
    VCR.use_cassette('requests layout') do
      get(:new, :service_response_id => 1)
      assert_response :success
      assert_select "body div.nyu-container", 1
      assert_select "div.request", 1
    end
  end

  test "holding requests layout xhr" do
    UserSession.create(users(:uid))
    VCR.use_cassette('requests layout xhr') do
      xhr :get, :new, :service_response_id => 1
      assert_response :success
      # Assert that no layout was included in the request
      assert_select "body", 0
      assert_select "div.nyu-container", 0
      assert_select "div.request", 1
    end
  end

  test "holding requests routes" do
    assert_equal "http://test.host/holding_requests/1/ill/BOBST", create_holding_request_url(1, "ill", "BOBST")
    assert_equal "http://test.host/holding_requests/1/on_order", create_holding_request_url(1, "on_order")
    assert_equal "http://test.host/holding_requests/1/recall", create_holding_request_url(1, "recall")
    assert_equal "http://test.host/holding_requests/1/in_processing", create_holding_request_url(1, "in_processing")
    assert_equal "http://test.host/holding_requests/1/available", create_holding_request_url(1, "available")
  end

  test "holding requests not logged in" do
    VCR.use_cassette('requests not logged in') do
      get(:new, {'service_response_id' => "1"})
      assert_response :unauthorized
    end
  end

  test "holding requests new available" do
    UserSession.create(users(:uid))
    VCR.use_cassette('requests new available') do
      get(:new, {'service_response_id' => "1"})
      assert_response :success
      assert_select 'div.request' do
        assert_select 'h2', {:count => 1,
          :text => "&quot;Virtual inequality : beyond the digital divide&quot; is available at NYU Bobst."},
            "Unexpected h2 text."
        assert_select 'form.request_available input[name="holding_request_type"]', {:count => 1, :value => "available"}
        assert_select 'ol.request_options li' do |elements|
          assert_equal(2, elements.length, "Problem with request options")
          assert_entire_option(elements.first)
          assert_scan_option(elements.last)
        end
        assert_select("p.delivery-help", 1)
      end
    end
  end

  test "holding requests new offsite" do
    UserSession.create(users(:uid))
    VCR.use_cassette('requests new offsite') do
      get(:new, {'service_response_id' => "3"})
      assert_response :success
      assert_select 'div.request' do |elements|
        assert_select 'h2', {:count => 1,
          :text => "&quot;Virtual inequality : beyond the digital divide&quot; is available from the New School Fogelman Library offsite storage facility."},
            "Unexpected h2 text."
        assert_select 'form.request_offsite input[name="holding_request_type"]', {:count => 1, :value => "offsite"}
        assert_select 'ol.request_options li' do |elements|
          assert_equal(2, elements.length, "Problem with request options")
          assert_entire_option(elements.first)
          assert_scan_option(elements.last)
        end
        assert_select("p.delivery-help", 1)
      end
    end
  end

  test "holding requests new recall" do
    UserSession.create(users(:uid))
    VCR.use_cassette('requests new recall') do
      get(:new, {'service_response_id' => "4"})
      assert_response :success
      assert_select 'div.request' do |elements|
        assert_select 'h2', {:count => 1,
          :text => "&quot;Programming Ruby : the pragmatic programmers&#x27; guide&quot; is checked out."},
            "Unexpected h2 text."
        assert_select 'form.request_recall input[name="holding_request_type"]', {:count => 1, :value => "recall"}
        assert_select("ol.request_options li") do |elements|
          assert_equal(2, elements.length, "Problem with request options")
          assert_ill_option(elements.last)
        end
        assert_select("p.delivery-help", 1)
      end
    end
  end

  test "holding requests new in processing" do
    UserSession.create(users(:uid))
    VCR.use_cassette('requests new in processing') do
      get(:new, {:service_response_id => 5})
      assert_response :success
      assert_select 'div.request' do |elements|
        assert_select 'h2', {:count => 1,
          :text => "&quot;Programming Ruby : the pragmatic programmers&#x27; guide&quot; is currently being processed by library staff."},
            "Unexpected h2 text."
        assert_select 'form.request_in_processing input[name="holding_request_type"]', {:count => 1, :value => "in_processing"}
        assert_select("ol.request_options li") do |elements|
          assert_equal(2, elements.length, "Problem with request options")
          assert_ill_option(elements.last)
        end
        assert_select("p.delivery-help", 1)
      end
    end
  end

  test "new ill holding request" do
    UserSession.create(users(:uid))
    VCR.use_cassette('requests new ill') do
      get(:new, {'service_response_id' => "11"})
      assert_select 'h2', {:count => 1,
        :text => "&quot;Naked statistics : stripping the dread from the data&quot; is currently out of circulation."},
          "Unexpected h2 text."
      assert_select("ol.request_options li") do |elements|
        assert_equal(1, elements.length, "Problem with request options")
        assert_ill_option(elements.first)
      end
      assert_select("p.delivery-help", 0)
    end
  end

  test "holding requests new mismatched item bsn" do
    UserSession.create(users(:uid))
    VCR.use_cassette('requests new mismatched item bsn') do
      get(:new, {:service_response_id => 6})
      assert_response :success
      assert_select 'div.request' do |elements|
        assert_select 'h2', {:count => 1,
          :text => "&quot;Chemistry : the molecular nature of matter and change&quot; is available at NYU Bobst."},
            "Unexpected h2 text."
        assert_select 'ol.request_options li', 2
        assert_select 'form.request_available input[name="holding_request_type"]', {:count => 1, :value => "available"}
      end
    end
  end

  test "holding requests new requested item" do
    UserSession.create(users(:uid))
    VCR.use_cassette('requests new requested item') do
      get(:new, {:service_response_id => 10})
      assert_response :success
      assert_select 'div.request' do |elements|
        assert_select 'h2', {:count => 1,
          :text => "&quot;Naked statistics : stripping the dread from the data&quot; is requested."},
            "Unexpected h2 text."
        assert_select 'ol.request_options li', 2
        assert_select 'form.request_recall input[name="holding_request_type"]', {:count => 1, :value => "recall"}
      end
    end
  end

  test "holding requests create available journal" do
    UserSession.create(users(:uid))
    VCR.use_cassette('requests create available journal') do
      get(:create, {:service_response_id => 2, :holding_request_type => "available"})
      assert_response :unauthorized
    end
  end

  test "holding requests create nonexistent type" do
    UserSession.create(users(:uid))
    VCR.use_cassette('requests create available journal') do
      get(:create, {:service_response_id => 2, :holding_request_type => "nonexistent"})
      assert_response :bad_request
    end
  end

  test "holding requests create aleph error" do
    UserSession.create(users(:uid))
    VCR.use_cassette('requests create aleph error') do
      get(:create, {:service_response_id => 1, :holding_request_type => "available"})
      assert_response :redirect
      assert_redirected_to "http://test.host/holding_requests/new/1"
      assert_equal "Failed to create request: Patron has already requested this item.", flash[:alert]
    end
  end

  test "holding requests create available" do
    UserSession.create(users(:uid))
    VCR.use_cassette('requests create available') do
      get(:create, {:service_response_id => 1, :holding_request_type => "available"})
      assert_response :redirect
      assert_redirected_to "http://test.host/holding_requests/1?pickup_location=BOBST&scan=false"
      assert_nil assigns(:sub_author)
      assert_nil assigns(:sub_title)
      assert_nil assigns(:pages)
      assert_nil assigns(:note_1)
    end
    get(:show, {:service_response_id => 1, :pickup_location => "BOBST", :scan => "false"})
    assert_select("div.text-success", {:count => 1,
      :text => "Your request has been processed. You will be notified when this item is available to pick up at NYU Bobst."})
  end

  test "holding requests create available scan" do
    UserSession.create(users(:uid))
    VCR.use_cassette('requests create available scan') do
      get(:create, {:service_response_id => 1, :holding_request_type => "available",
        :entire => "no", sub_author: "Sub Author", sub_title: "Sub Title", pages: "1-10", note_1: "Note 1"})
      assert_response :redirect
      assert_redirected_to "http://test.host/holding_requests/1?pickup_location=BOBST&scan=true"
      assert_response :redirect
      assert_redirected_to "http://test.host/holding_requests/1?pickup_location=BOBST&scan=true"
      assert_not_nil assigns(:sub_author)
      assert_equal "Sub Author", assigns(:sub_author)
      assert_not_nil assigns(:sub_title)
      assert_equal "Sub Title", assigns(:sub_title)
      assert_not_nil assigns(:pages)
      assert_equal "1-10", assigns(:pages)
      assert_not_nil assigns(:note_1)
      assert_equal "Note 1", assigns(:note_1)
    end
    get(:show, {:service_response_id => 1, :pickup_location => "BOBST", :scan => "true"})
    assert_select("div.text-success", {:count => 1,
      :text => "Your scan request has been processed. You will receive an email when the item is available."})
  end

  test "holding requests create offsite" do
    UserSession.create(users(:uid))
    VCR.use_cassette('requests create offsite') do
      get(:create, {:service_response_id => 3, :holding_request_type => "offsite"})
      assert_response :redirect
      assert_redirected_to "http://test.host/holding_requests/3?pickup_location=TNSFO&scan=false"
    end
    get(:show, {:service_response_id => 3, :pickup_location => "TNSFO", :scan => "false"})
    assert_select("div.text-success", {:count => 1,
      :text => "Your request has been processed. You will be notified when this item is available to pick up at New School Fogelman Library."})
  end

  test "holding requests create recall" do
    UserSession.create(users(:uid))
    VCR.use_cassette('requests create recall') do
      get(:create, {:service_response_id => 4, :holding_request_type => "recall"})
      assert_response :redirect
      assert_redirected_to "http://test.host/holding_requests/4?pickup_location=NCOUR&scan=false"
    end
    get(:show, {:service_response_id => 4, :pickup_location => "NCOUR", :scan => "false"})
    assert_select("div.text-success", {:count => 1,
      :text => "Your request has been processed. You will be notified when this item is available to pick up at NYU Courant."})
  end

  test "holding requests create in processing" do
    UserSession.create(users(:uid))
    VCR.use_cassette('requests create in processing') do
      get(:create, {:service_response_id => 5, :holding_request_type => "in_processing"})
      assert_response :redirect
      assert_redirected_to "http://test.host/holding_requests/5?pickup_location=NABUD&scan=false"
    end
    get(:show, {:service_response_id => 5, :pickup_location => "NABUD", :scan => "false"})
    assert_select("div.text-success", {:count => 1,
      :text => "Your request has been processed. You will be notified when this item is available to pick up at NYU Abu Dhabi Library (UAE)."})
  end

  test "holding requests create ill" do
    UserSession.create(users(:uid))
    get(:create, {:service_response_id => 5, :holding_request_type => "ill"})
    assert_response :redirect
    assert @response.location.starts_with?("http://ill.library.nyu.edu/illiad/illiad.dll/OpenURL?url_ver=Z39.88-2004&url_ctx_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Actx&ctx_ver=Z39.88-2004&")
  end

  test "holding requests create mismatched item bsn" do
    UserSession.create(users(:uid))
    VCR.use_cassette('requests create mismatched item bsn') do
      get(:create, {:service_response_id => 6, :holding_request_type => "available"})
      assert_response :redirect
      assert_redirected_to "http://test.host/holding_requests/6?pickup_location=BOBST&scan=false"
    end
    get(:show, {:service_response_id => 5, :pickup_location => "BOBST", :scan => "false"})
    assert_select("div.text-success", {:count => 1,
      :text => "Your request has been processed. You will be notified when this item is available to pick up at NYU Bobst."})
  end

  test "missing service response in new" do
    UserSession.create(users(:uid))
    assert_nothing_raised {
      get(:new, {:service_response_id => 1000})
      assert_select("div.text-error", {:count => 1,
        :text => "We&#x27;re very sorry. Something went wrong. Please refresh the page and make your request again."})
    }
  end

  test "missing service response in create" do
    UserSession.create(users(:uid))
    assert_nothing_raised {
      get(:create, {:service_response_id => 1000, :holding_request_type => "available"})
    }
  end

  def assert_entire_option(candidate)
    assert_select(candidate, 'label.radio input[type="radio"]',
      { count: 1, id: "entire_yes", name: "entire", value: "yes" })
  end

  def assert_scan_option(candidate)
    assert_select(candidate, 'label.radio input[type="radio"]',
      { count: 1, id: "entire_no", name: "entire", value: "no" })
    assert_select(candidate, 'label.radio fieldset', 1)
  end

  def assert_ill_option(candidate)
    assert_select(candidate, "div.section a",
      { count: 1, text: "Request this item from another library via Interlibrary Loan (ILL)" })
  end
end
