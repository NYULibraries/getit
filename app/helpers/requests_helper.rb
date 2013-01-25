module RequestsHelper
  # Constants for 'requestability' value.
  RequestableYes = 'yes' # Yes, obviously
  RequestableDeferred = 'deferred' # Defer the requestability decision
  RequestableNo = 'no' # No
  RequestableUnknown = 'unknown' # Unknown, but essentially no

  # Define various configuration options
  def request_types
    @request_types ||= ["available", "ill", "in_processing", "offsite", "on_order", "recall"]
  end

  def request_attributes
    @request_attributes ||= [:status, :status_code, :adm_library_code, :sub_library, 
      :sub_library_code,:source_record_id, :item_id, :item_status_code, 
        :item_process_status_code, :circulation_status]
  end
  protected :request_attributes

  def request_instance_attributes_set(attributes)
    request_attributes.each {|attr_name|
      instance_variable_set("@#{attr_name}".to_sym, attributes[attr_name])}
  end
  protected :request_instance_attributes_set

  # Is a request available for the item/user combo?
  def request?
    (request_ill? or request_available? or request_recall? or
      request_in_processing? or request_on_order? or request_offsite?)
  end

  # Is an available request available for the item/user combo?
  def request_available?
    requestable?({:status => ["Available"]}, {:hold_on_shelf => "Y", :hold_permission => "Y"})
  end

  # Is a recall request available for the item/user combo?
  def request_recall?
    requestable?({:status => ["Requested"], :status_code => ["checked_out"]}, {:hold_permission => "Y"})
  end

  # Is an in processing request available for the item/user combo?
  def request_in_processing?
    requestable?({:status => ["In Processing", "In Transit"]}, {:hold_permission => "Y"})
  end

  # Is an offsite request available for the item/user combo?
  def request_offsite?
    requestable?({:status => ["Offsite Available"]}, {:hold_permission => "Y"})
  end

  # Is an on order request available for the item/user combo?
  def request_on_order?
    requestable?({:status => ["On Order"]}, {:hold_permission => "Y"})
  end

  # Is an ILL request available for the item combo?
  # We don't care about user permissions when we're dealing with ILL.
  def request_ill?
    item_state_requestable?({:status => ["Request ILL", "Requested", "On Order", "In Processing", "In Transit"],
      :status_code => ["checked_out", "billed_as_lost"]})
  end

  # We need to determine if the item state is valid for the type of request we're 
  # trying to make (e.g. recall, offsite)
  # We need to determine if the user's permissions are in a state that
  # is valid for the type of request we're trying to make (e.g. recall, offsite)
  # In order to determine which state we are in we need a combination of 
  #   1. item data and requestable states for that item data
  #   2. current user permissions and requestable states for those user permissions
  def requestable?(item_requestable_states, user_permissions_requestable_states)
    # Determine if the item is in a requestable state for the type of request we're making.
    return false unless item_state_requestable?(item_requestable_states)
    # If always requestable, we can return true if user session is nil
    return true if (item_requestability.eql?(RequestableYes) and current_user_session.nil?)
    return (item_requestable? and user_permissions_state_requestable?(user_permissions_requestable_states))
  end
  private :requestable?

  # Is the item requestable (possibly deferring the decision to whether the user can request)
  def item_requestable?
    return [RequestableYes, RequestableDeferred].include?(item_requestability)
  end
  private :item_requestable?

  # Indicates whether the item is in a requestable state
  # This is an OR test.
  def item_state_requestable?(requestable_states={})
    requestable_states.each { |key, value|
      return true if value.include?(instance_variable_get("@#{key}".to_sym)) }
    return false
  end
  private :item_state_requestable?

  # Indicates whether the user permissions are in a requestable state
  # This is an AND test.
  def user_permissions_state_requestable?(requestable_states={})
    requestable_states.each_pair { |key, value|
      return false unless value.eql?(user_permissions[key]) }
    return true
  end
  private :user_permissions_state_requestable?

  # Return the "requestability" of the item, i.e. under what
  # circumstances is the item requestable
  def item_requestability
    # TODO: Move this into the AlephHelper
    nonrequestable_circ_statuses = ["Reshelving"]
    requestable_item_hold_values = ["C"]
    requestable_ill_values = ["Y"]
    user_requestable_item_hold_values = ["Y"]
    return RequestableUnknown if @adm_library_code.nil? or @sub_library_code.nil?
    # Handle Non-Requestable Circ Statuses
    return RequestableNo if nonrequestable_circ_statuses.include?(@circulation_status)
    # Check item permissions
    # TODO: Abstract out the item permissions stuff.
    return RequestableYes if (requestable_item_hold_values.include?(item_permissions[:hold_request]) or 
      requestable_ill_values.include?(item_permissions[:photocopy_request]))
    return RequestableDeferred if user_requestable_item_hold_values.include?(item_permissions[:hold_request])
    return RequestableNo
  end
  private :item_requestability

  # Get the item permissions from the Aleph tables
  def item_permissions
    @item_permissions ||= (@adm_library_code.nil?) ? {} :
      aleph_helper.item_permissions(:adm_library_code => @adm_library_code.downcase, 
        :sub_library_code => @sub_library_code, :item_status_code => @item_status_code, 
          :item_process_status_code => @item_process_status_code) 
  end
  private :item_permissions

  # Get the user's permissions
  def user_permissions
    return {} unless current_user
    @user_permissions = current_user.user_attributes[:aleph_permissions][@sub_library_code]
    unless @user_permissions
      current_user.user_attributes[:aleph_permissions][@sub_library_code] = 
        current_user_session.aleph_bor_auth_permissions(current_user.user_attributes[:nyuidn],
          current_user.user_attributes[:verification], @adm_library_code, @sub_library_code)
      current_user.save_without_session_maintenance
      @user_permissions = current_user.user_attributes[:aleph_permissions][@sub_library_code]
    end
    @user_permissions
  end
  private :user_permissions

  def aleph_helper
    @aleph_helper ||= Exlibris::Aleph::TabHelper.instance()
  end
  private :aleph_helper

  def permission_error
    "You do not have permission to perform this request.".html_safe +
      "Please contact <a href=\"mailto:access.services@nyu.edu\">access.services@nyu.edu</a> for further information.".html_safe
  end
  protected :permission_error

  def unexpected_error
    "An unexpected error has occurred.".html_safe +
      "Please contact <a href=\"mailto:web.services@nyu.edu\">web.services@nyu.edu</a> to address this issue.".html_safe
  end
  protected :unexpected_error

  # Display header for the given title
  def display_header(title)
    return title + " is requested." if @status.match(/Requested/)
    return title + " is checked out." if request_recall?
    return title + " is available at #{@sub_library}." if request_available?
    return title + " is available from the #{@sub_library} offsite storage facility." if request_offsite?
    return title + " is currently being processed by library staff." if request_in_processing?
    return title + " is on order." if request_on_order?
    return title + " is currently out of circulation." if request_ill?
  end

  def display_request_form(request_type, &block)
    form_tag(request_url(params[:service_response_id]), :class => "modal_dialog_form request_#{request_type}" ) do
      request_type_field = hidden_field_tag(:request_type, request_type)
      content = capture(&block)
      output = ActiveSupport::SafeBuffer.new
      output.safe_concat(content_tag(:div, request_type_field, :style => 'margin:0;padding:0;display:inline'))
      output << content
    end
  end

  def display_request_option(&block)
    content_tag(:li) do
      content_tag(:div, :class => "section") do
        yield
      end
    end
  end

  def display_request_link_or_text(text, request_type)
    (pickup_locations.length > 1) ? 
      "Recall this item from a fellow library user.".html_safe :
      link_to(text, create_request_url(params[:service_response_id], 
        request_type, pickup_locations.first.last),
          {:target => "_blank", :class => "ajax_window"})+ tag(:br)
  end

  # Display pickup locations
  def display_pickup_locations
    if pickup_locations.length > 1
      label("pickup_location", "Select pickup location:") +
       select_tag('pickup_location', options_for_select(pickup_locations))
    else
      pickup_location = (pickup_locations.length == 1) ? 
        pickup_locations.first.first : sub_library
      pickup_location_code = (pickup_locations.length == 1) ? 
        pickup_locations.first.last : sub_library_code
      content_tag(:strong, "Pickup location is #{pickup_location}") +
        hidden_field_tag("pickup_location", pickup_location_code)
    end
  end

  # Display delivery times link
  def display_delivery_times_link
    content_tag(:div) {
      link_to("See delivery times", 
        "http://library.nyu.edu/services/deliveryservices.html", 
          :target => "_blank") } if pickup_locations.length > 1
  end

  # Display delivery help link
  def display_delivery_help_link
    content_tag(:p) {
      link_to("http://library.nyu.edu/help/requesthelp.html", :target => "_blank") do
        content_tag(:i, nil, :class => "icons-famfamfam-information") +
          content_tag(:span, "Not sure which option to choose?")
      end
    } if request_option_count > 1
  end

  def request_option_count
    count = 0
    count += 1 if request_available?
    count += 1 if request_recall?
    count += 1 if request_in_processing?
    count += 1 if request_on_order?
    count += 1 if request_offsite?
    count += 1 if request_ill?
    return count
  end

  # Gather and return pickup locations
  def pickup_locations
    return @pickup_locations if defined?(@pickup_locations)
    patron_status = user_permissions[:bor_status]
    item_availability_status = 
      (@status == "Offsite Available" or @status == "Available") ? "Y" : "N"
    # Return empty pickup locations if patron status adm library or sub library
    # adm library, sub library or sub library pickup locations is nil
    return [] if patron_status.nil? or @adm_library_code.nil? or @sub_library_code.nil?
    # Get Aleph pick up locations for the given sub library
    @pickup_locations = aleph_helper.item_pickup_locations(
      :adm_library_code => @adm_library_code, :sub_library_code => @sub_library_code,
        :item_status_code => @item_status_code, :item_process_status_code => @item_process_status_code,
          :bor_status => patron_status, :availability_status => item_availability_status)
    @pickup_locations = (@pickup_locations.nil?) ? 
      [[@sub_library, @sub_library_code]] : @pickup_locations.collect { |location_code| 
        [decode_sub_library(location_code), location_code] }
  end

  # Display scan elements
  def display_scan_elements
    label("sub_author", "Author of part:") +
      text_field_tag("sub_author") + "<br />".html_safe +
    label("sub_title", "Title of part:") +
      text_field_tag("sub_title") + "<br />".html_safe +
    label("pages", "Pages (e.g., 7-12; 5, 6-8, 10-15):") +
      text_field_tag("pages") + "<br />".html_safe +
    label("note_1", "Notes:") +
      text_field_tag("note_1", nil, :maxlength => 50) + "<br />".html_safe
  end

  # Decode sublibrary
  def decode_sub_library(code)
    value = aleph_helper.sub_library_text(code)
    return (value.nil?) ? code : value
  end
end