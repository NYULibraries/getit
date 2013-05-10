module HoldingRequestsHelper

  # Display header for the given holding
  def request_header(title)
    return "#{title} is requested." if @holding.requested?
    return "#{title} is checked out." if @holding.checked_out?
    return "#{title} is available at #{@holding.sub_library}." if @holding.available?
    return "#{title} is available from the #{@holding.sub_library} offsite storage facility." if @holding.offsite?
    return "#{title} is currently being processed by library staff." if @holding.in_processing?
    return "#{title} is on order." if @holding.on_order?
    return "#{title} is currently out of circulation." if @holding.ill?
  end

  # Request form to offer holding request options
  def request_form(holding_request_type, &block)
    form_tag(holding_request_url(params[:service_response_id]), :class => "modal_dialog_form request_#{holding_request_type}" ) do
      holding_request_type_field = hidden_field_tag(:holding_request_type, holding_request_type)
      content = capture(&block)
      output = ActiveSupport::SafeBuffer.new
      output.safe_concat(content_tag(:div, holding_request_type_field, :style => 'margin:0;padding:0;display:inline'))
      output << content
    end
  end

  # Request option for a request form
  def request_option(&block)
    content_tag(:li) do
      content_tag(:div, :class => "section") do
        yield
      end
    end
  end

  # Request option the entire item (with radio button).
  # Request for the entire item to be delivered to a pickup location
  def entire_request_option
    request_option do
      label_tag(:entire_yes, class: "radio") {
        radio_button_tag("entire",  "yes", :checked => true) +
        "Request this item to be delivered to an NYU Library of your choice." +
        pickup_locations_fields + delivery_times
      }
    end
  end

  # Request option for a scanned of a portion of the item (with radio button).
  # Request for a portion of the item to scanned and delivered electronically.
  def scan_portion_request_option
    request_option do
      label_tag(:entire_no, class: "radio") {
        radio_button_tag("entire",  "no") +
        "Request that portions of the item be scanned and delivered electronically." +
        fair_use_disclaimer + scan_fields
      }
    end
  end

  # Request a scan of a portion of the item option (with radio button).
  def request_link_or_text(text, holding_request_type)
    (pickup_locations.length > 1) ?
      text.html_safe :
      link_to(text, create_holding_request_url(params[:service_response_id],
        holding_request_type, pickup_locations.first.last),
          {:target => "_blank", :class => "ajax_window"})+ tag(:br)
  end

  # Pickup locations fields for an item request
  # If there are multiple pickup locations, a select box is rendered.
  # If there is only one pickup location, text specifying the pickup
  # location with a hidden field is rendered.
  def pickup_locations_fields
    field_set_tag do
      if pickup_locations.length > 1
        label_tag("pickup_location", "Select pickup location:") +
         select_tag('pickup_location', options_for_select(pickup_locations))
      else
        pickup_location = (pickup_locations.length == 1) ?
          pickup_locations.first.first : @holding.sub_library
        pickup_location_code = (pickup_locations.length == 1) ?
          pickup_locations.first.last : @holding.sub_library_code
        content_tag(:strong, "Pickup location is #{pickup_location}") +
          hidden_field_tag("pickup_location", pickup_location_code)
      end
    end
  end

  # Scan fields for the scanned portion request option.
  # Fields include
  #   - Author of Part
  #   - Title of Part
  #   - Desired pages
  #   - Notes
  def scan_fields
    field_set_tag do
      label_tag("sub_author", "Author of part:") +
        text_field_tag("sub_author") +
      label_tag("sub_title", "Title of part:") +
        text_field_tag("sub_title") +
      label_tag("pages", "Pages (e.g., 7-12; 5, 6-8, 10-15):") +
        text_field_tag("pages") +
      label_tag("note_1", "Notes:") +
        text_field_tag("note_1", nil, :maxlength => 50)
    end
  end

  # Expected delivery times.
  # Provide a link to the delivery times that patrons can expect
  # for the request.
  # Only display delivery times if mulitple pickup locations
  def delivery_times
    content_tag(:p, link_to_delivery_times) if pickup_locations.length > 1
  end

  # Fair user disclaimer for scanned resources.
  # Provide a link to fair use guidelines
  def fair_use_disclaimer
    content_tag(:p) do
      "(Requests must be within ".html_safe + link_to_fair_use_guidelines + ".)".html_safe
    end
  end

  # Help for delivery choices.
  # Provide a link to helpful information explaining
  # the various choices if there are multiple choices
  def delivery_help
    content_tag(:p, link_to_delivery_help) if request_option_count > 1
  end

  # Delivery times link
  def link_to_delivery_times
    link_to("See delivery times",
      "http://library.nyu.edu/services/deliveryservices.html#how_long",
        :target => "_blank")
  end

  # Fair use link
  def link_to_fair_use_guidelines
    link_to("fair use guidelines",
      "http://library.nyu.edu/copyright/#fairuse",
        target: "_blank")
  end

  # Delivery help link
  def link_to_delivery_help
    link_to("http://library.nyu.edu/help/requesthelp.html", :target => "_blank") do
      icon_tag(:info) + content_tag(:span, "Not sure which option to choose?")
    end
  end

  # Number of request options available for user/holding combo.
  def request_option_count
    count = 0
    count += 2 if @authorizer.available?
    count += 1 if @authorizer.recall?
    count += 1 if @authorizer.in_processing?
    count += 1 if @authorizer.on_order?
    count += 2 if @authorizer.offsite?
    count += 1 if @authorizer.ill?
    return count
  end

  # Gather and return pickup locations for the user/holding combo.
  # Returns an Array of 2 element Arrays with the sub library and sub library code of the
  # as the elements
  #   e.g. [["NYU Bobst", "BOBST"], ["Courant Library", "COUR"]]
  def pickup_locations
    return @pickup_locations if defined?(@pickup_locations)
    # Return empty pickup locations if current user's borrower status,
    # holding's adm library code or holdling's sub library code is nil
    # since we need those to get the pickup locations in the first place
    return [] if bor_status.nil? or @holding.adm_library_code.nil? or @holding.sub_library_code.nil?
    # If we didn't get any pickup locations from the Aleph tables for the user/holding combo,
    # return 1 pickup location based on the holding's sub library
    @pickup_locations = (aleph_helper_pickup_locations.nil?) ?
      [[@holding.sub_library, @holding.sub_library_code]] : aleph_helper_pickup_locations.collect { |location_code|
        [decode_sub_library(location_code), location_code] }
  end

  # Return the pickup locations from the aleph helper for the user/holding combo.
  def aleph_helper_pickup_locations
    # Get Aleph pick up locations for the given holding's sub library
    @aleph_helper_pickup_locations ||= aleph_helper.item_pickup_locations(
      adm_library_code: @holding.adm_library_code.downcase, sub_library_code: @holding.sub_library_code,
        item_status_code: @holding.item_status_code, item_process_status_code: @holding.item_process_status_code,
          availability_status: @holding.availability_status, bor_status: bor_status)
  end
  private :aleph_helper_pickup_locations

  # Return the borrower status for the current user/holding combo,
  # i.e. the user's status for the holding's ADM and sub library.
  def bor_status
    @bor_status ||= user_permissions[:bor_status]
  end
  private :bor_status

  # Instance of the Aleph tables helper
  def aleph_helper
    @aleph_helper ||= Exlibris::Aleph::TabHelper.instance()
  end
  private :aleph_helper

  # User permissions for the holding,
  # i.e. the user's permissions for the holding's ADM and sub library.
  def user_permissions
    @user_permission ||=
      current_user.aleph_permissions_by_sub_library_code(@holding.adm_library_code, @holding.sub_library_code)
  end
  private :user_permissions

  # Decode sublibrary
  def decode_sub_library(code)
    value = aleph_helper.sub_library_text(code)
    return (value.nil?) ? code : value
  end
end
