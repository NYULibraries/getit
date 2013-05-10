require 'test_helper'
class HoldingRequestsHelperTest < ActionView::TestCase
  include NyulibrariesHelper

  setup do
    @holding = nil
    @requested_holding = Holding.new(service_responses(:nyu_primo_naked_statistics))
    @available_holding = Holding.new(service_responses(:nyu_aleph_available_book))
    @offsite_holding = Holding.new(service_responses(:nyu_aleph_offsite_book))
    @checked_out_holding = Holding.new(service_responses(:nyu_aleph_recall_book))
    @in_processing_holding = Holding.new(service_responses(:nyu_aleph_in_processing_book))
    # @on_order_holding = Holding.new(service_responses(:nyu_aleph_on_order_book))
    @ill_holding = Holding.new(service_responses(:nyu_aleph_ill_holding))
  end

  test "should return 'requested' header " do
    @holding = @requested_holding
    assert_equal("Some Title is requested.", request_header("Some Title"))
  end

  test "should return 'available' header " do
    @holding = @available_holding
    assert_equal("Some Title is available at NYU Bobst.", request_header("Some Title"))
  end

  test "should return 'offsite' header " do
    @holding = @offsite_holding
    assert_equal("Some Title is available from the New School Fogelman Library offsite storage facility.", request_header("Some Title"))
  end

  test "should return 'checked out' header " do
    @holding = @checked_out_holding
    assert_equal("Some Title is checked out.", request_header("Some Title"))
  end

  test "should return 'in processing' header " do
    @holding = @in_processing_holding
    assert_equal("Some Title is currently being processed by library staff.", request_header("Some Title"))
  end

  test "should return 'ill' header " do
    @holding = @ill_holding
    assert_equal("Some Title is currently out of circulation.", request_header("Some Title"))
  end

  test "should return 2 options count for available holding" do
    @authorizer = HoldingRequestAuthorizer.new(@available_holding, current_user)
    VCR.use_cassette('user aleph permissions') do
      assert_equal(2, request_options_count)
    end
  end

  test "should return 2 options count for offsite holding" do
    @authorizer = HoldingRequestAuthorizer.new(@offsite_holding, current_user)
    VCR.use_cassette('user aleph permissions') do
      assert_equal(2, request_options_count)
    end
  end

  test "should return 2 options count for checked out holding" do
    @authorizer = HoldingRequestAuthorizer.new(@checked_out_holding, current_user)
    VCR.use_cassette('user aleph permissions') do
      assert_equal(2, request_options_count)
    end
  end

  test "should return 2 options count for in processing holding" do
    @authorizer = HoldingRequestAuthorizer.new(@in_processing_holding, current_user)
    VCR.use_cassette('user aleph permissions') do
      assert_equal(2, request_options_count)
    end
  end

  test "should return 1 options count for ill holding" do
    @authorizer = HoldingRequestAuthorizer.new(@ill_holding, current_user)
    VCR.use_cassette('user aleph permissions') do
      assert_equal(1, request_options_count)
    end
  end

  test "should return link rather than text" do
    @pickup_locations = [["NYU Bobst", "BOBST"]]
    @service_response_id = 1
    assert_equal(
      "<p>" +
        "<a href=\"http://test.host/holding_requests/1/available/BOBST\" class=\"ajax_window\" target=\"_blank\">" +
          "Some request text" +
        "</a>" +
      "</p>", request_link_or_text("Some request text", 'available'))
  end

  test "should return text rather than link" do
    @pickup_locations = [["NYU Bobst", "BOBST"], ["Courant Library", "COUR"]]
    @service_response_id = 1
    assert_equal("Some request text", request_link_or_text("Some request text", 'available'))
  end

  test "should return delivery times" do
    @pickup_locations = [["NYU Bobst", "BOBST"], ["Courant Library", "COUR"]]
    assert_not_nil(delivery_times)
    assert_equal(
      "<p class=\"delivery-times\">" +
        "<a href=\"http://library.nyu.edu/services/deliveryservices.html#how_long\" target=\"_blank\">See delivery times</a>" +
      "</p>", delivery_times)
  end

  test "should not return delivery times" do
    @pickup_locations = [["NYU Bobst", "BOBST"]]
    assert_nil(delivery_times)
  end

  test "should return delivery link" do
    assert_equal(
      "<a href=\"http://library.nyu.edu/services/deliveryservices.html#how_long\" target=\"_blank\">See delivery times</a>",
        link_to_delivery_times)
  end

  test "should return create available link" do
    @pickup_locations = [["NYU Bobst", "BOBST"]]
    @service_response_id = 1
    assert_equal(
      "<a href=\"http://test.host/holding_requests/1/available/BOBST\" class=\"ajax_window\" target=\"_blank\">" +
        "Some request text" +
      "</a>", link_to_create_holding_request("Some request text", "available"))
  end

  test "should return delivery help link" do
    assert_equal(
      "<a href=\"http://library.nyu.edu/help/requesthelp.html\" target=\"_blank\">" +
        "<i class=\"icons-famfamfam-information\"></i>" +
        "<span>Not sure which option to choose?</span>" +
      "</a>", link_to_delivery_help)
  end

  test "should return fair use link" do
    assert_equal(
      "<a href=\"http://library.nyu.edu/copyright/#fairuse\" target=\"_blank\">fair use guidelines</a>",
        link_to_fair_use_guidelines)
  end

  test "should return 'entire' request option" do
    @holding = @available_holding
    VCR.use_cassette('user aleph permissions') do
      assert_equal(
        "<li>"+
          "<div class=\"section\">" +
            "<label class=\"radio\" for=\"entire_yes\">" +
              "<input checked=\"checked\" id=\"entire_yes\" name=\"entire\" type=\"radio\" value=\"yes\" />" +
              "Request this item to be delivered to an NYU Library of your choice." +
              "<fieldset>" +
                "<label for=\"pickup_location\">Select pickup location:</label>" +
                "<select id=\"pickup_location\" name=\"pickup_location\">" +
                  "<option value=\"BOBST\">NYU Bobst</option>\n" +
                  "<option value=\"NCOUR\">NYU Courant</option>\n" +
                  "<option value=\"NIFA\">NYU Institute of Fine Arts</option>\n" +
                  "<option value=\"NISAW\">NYU Inst Study Ancient World</option>\n" +
                  "<option value=\"NREI\">NYU Jack Brause</option>\n" +
                  "<option value=\"NPOLY\">NYU Poly</option>\n" +
                  "<option value=\"NYUAB\">NYU Abu Dhabi Library (UAE)</option>\n" +
                  "<option value=\"NYUSE\">NYUAD Ctr for Sci &amp; Eng (UAE)</option>\n" +
                  "<option value=\"NYUSS\">NYUAD Sama Fac Offices (UAE)</option>" +
                "</select>" +
              "</fieldset>" +
              "<p class=\"delivery-times\">" +
                "<a href=\"http://library.nyu.edu/services/deliveryservices.html#how_long\" target=\"_blank\">See delivery times</a>" +
              "</p>" +
            "</label>" +
          "</div>" +
        "</li>", entire_request_option)
    end
  end

  test "should return 'scanned portion' request option" do
    @holding = @available_holding
    assert_equal(
      "<li>" +
        "<div class=\"section\">" +
          "<label class=\"radio\" for=\"entire_no\">" +
            "<input id=\"entire_no\" name=\"entire\" type=\"radio\" value=\"no\" />" +
            "Request that portions of the item be scanned and delivered electronically." +
            "<p class=\"fair-use-disclaimer\">" +
              "(Requests must be within "+
              "<a href=\"http://library.nyu.edu/copyright/#fairuse\" target=\"_blank\">fair use guidelines</a>" +
              ".)" +
            "</p>" +
            "<fieldset>" +
              "<label for=\"sub_author\">Author of part:</label>" +
              "<input id=\"sub_author\" name=\"sub_author\" type=\"text\" />" +
              "<label for=\"sub_title\">Title of part:</label>" +
              "<input id=\"sub_title\" name=\"sub_title\" type=\"text\" />" +
              "<label for=\"pages\">Pages (e.g., 7-12; 5, 6-8, 10-15):</label>" +
              "<input id=\"pages\" name=\"pages\" type=\"text\" />" +
              "<label for=\"note_1\">Notes:</label>" +
              "<input id=\"note_1\" maxlength=\"50\" name=\"note_1\" type=\"text\" />" +
            "</fieldset>" +
          "</label>" +
        "</div>" +
      "</li>",
      scan_portion_request_option)
  end

  test "should return borrower's status" do
    @holding = @available_holding
    VCR.use_cassette('user aleph permissions') do
      assert_equal("51", bor_status)
    end
  end

  test "should return pickup locations" do
    @holding = @available_holding
    VCR.use_cassette('user aleph permissions') do
      assert_equal(Array, pickup_locations.class)
      assert_equal(9, pickup_locations.length)
    end
  end

  # Mock current user function for tests
  def current_user
    @current_user ||= users(:uid)
  end
  private :current_user
end
