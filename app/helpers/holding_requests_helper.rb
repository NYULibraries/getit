module HoldingRequestsHelper

  # Is a holding_request available for the item/user combo?
  # e.g. holding_request?(status, status_code, holding_requestability, adm_library_code, sub_library_code)
  def holding_request?(*args)
    (ill?(*args) or available?(*args) or 
      recall?(*args) or in_processing?(*args) or 
        on_order?(*args) or offsite?(*args))
  end

  # Is an available request available for the item/user combo?
  # e.g. available?(status, status_code, holding_requestability, adm_library_code, sub_library_code)
  # If args are missing, defaults to instance variables
  def available?(*args)
    (status, status_code, holding_requestability, 
      adm_library_code, sub_library_code) = defaults(*args)
    (["Available"].include?(status) and 
      requestable?({:hold_permission => "Y", :hold_on_shelf => "Y"}, 
        holding_requestability, adm_library_code, sub_library_code))
  end

  # Is a recall request available for the item/user combo?
  # e.g. recall?(status, status_code, holding_requestability, adm_library_code, sub_library_code)
  # If args are missing, defaults to instance variables
  def recall?(*args)
    (status, status_code, holding_requestability, 
      adm_library_code, sub_library_code) = defaults(*args)
    ((["Requested"].include?(status) or
      ["checked_out", "requested"].include?(status_code)) and
        requestable?({:hold_permission => "Y"}, holding_requestability, 
          adm_library_code, sub_library_code))
  end

  # Is an in processing request available for the item/user combo?
  # e.g. in_processing?(status, status_code, holding_requestability, adm_library_code, sub_library_code)
  # If args are missing, defaults to instance variables
  def in_processing?(*args)
    (status, status_code, holding_requestability, 
      adm_library_code, sub_library_code) = defaults(*args)
    (["In Processing", "In Transit"].include?(status) and 
      requestable?({:hold_permission => "Y"}, holding_requestability, 
        adm_library_code, sub_library_code))
  end

  # Is an offsite request available for the item/user combo?
  # e.g. offsite?(status, status_code, holding_requestability, adm_library_code, sub_library_code)
  # If args are missing, defaults to instance variables
  def offsite?(*args)
    (status, status_code, holding_requestability, 
      adm_library_code, sub_library_code) = defaults(*args)
    (["Offsite Available"].include?(status) and 
      requestable?({:hold_permission => "Y"}, holding_requestability, 
        adm_library_code, sub_library_code))
  end

  # Is an on order request available for the item/user combo?
  # e.g. on_order?(status, status_code, holding_requestability, adm_library_code, sub_library_code)
  # If args are missing, defaults to instance variables
  def on_order?(*args)
    (status, status_code, holding_requestability, 
      adm_library_code, sub_library_code) = defaults(*args)
    (["On Order"].include?(status) and 
      requestable?({:hold_permission => "Y"}, holding_requestability, 
        adm_library_code, sub_library_code))
  end

  # Is an ILL request available for the item combo?
  # e.g. ill?(status, status_code, holding_requestability)
  # If args are missing, defaults to instance variables
  def ill?(*args)
    # We don't care about user permissions when we're dealing with ILL.
    (status, status_code, holding_requestability, 
      adm_library_code, sub_library_code) = defaults(*args)
    (["Request ILL", "Requested", "On Order", "In Processing", "In Transit"].include?(status) or
       ["checked_out", "billed_as_lost", "requested"].include?(status_code))
  end

  def defaults(*args)
    [ args.fetch(0, @status), args.fetch(1, @status_code), 
        args.fetch(2, @requestability), args.fetch(3, @adm_library_code),
          args.fetch(4, @sub_library_code) ]
  end
  private :defaults

  # We need to determine if the item state is valid for the type of request we're 
  # trying to make (e.g. recall, offsite)
  # We need to determine if the user's permissions are in a state that
  # is valid for the type of request we're trying to make (e.g. recall, offsite)
  # In order to determine which state we are in we need a combination of 
  #   1. item data and requestable states for that item data
  #   2. current user permissions and requestable states for those user permissions
  def requestable?(user_permissions_requestable_states, holding_requestability, adm_library_code, sub_library_code)
    # If always requestable, we can return true even if user session is nil
    return true if (holding_requestability.eql?(Exlibris::Primo::Source::NyuAleph::RequestableYes) and 
      current_user_session.nil?)
    return (item_requestable?(holding_requestability) and 
      user_permissions_state_requestable?(user_permissions_requestable_states, adm_library_code, sub_library_code))
  end
  private :requestable?

  # Is the item requestable (possibly deferring the decision to whether the user can request)
  def item_requestable?(holding_requestability)
    return [Exlibris::Primo::Source::NyuAleph::RequestableYes,
      Exlibris::Primo::Source::NyuAleph::RequestableDeferred].include?(holding_requestability)
  end
  private :item_requestable?

  # Indicates whether the user permissions are in a requestable state
  # This is an AND test.
  def user_permissions_state_requestable?(requestable_states={}, adm_library_code, sub_library_code)
    user_permissions = user_permissions(adm_library_code, sub_library_code)
    requestable_states.each_pair { |key, value|
      return false unless value.eql?(user_permissions[key]) }
    return true
  end
  private :user_permissions_state_requestable?

  def user_permissions(adm_library_code, sub_library_code)
    return {} if current_user.nil?
    current_user.aleph_permissions_by_sub_library_code(adm_library_code, sub_library_code)
  end
  private :user_permissions

  def aleph_helper
    @aleph_helper ||= Exlibris::Aleph::TabHelper.instance()
  end
  private :aleph_helper

  # Display header for the given holding
  def display_header(title, sub_library)
    return title + " is requested." if @status.match(/Requested/)
    return title + " is checked out." if recall?
    return title + " is available at #{sub_library}." if available?
    return title + " is available from the #{sub_library} offsite storage facility." if offsite?
    return title + " is currently being processed by library staff." if in_processing?
    return title + " is on order." if on_order?
    return title + " is currently out of circulation." if ill?
  end

  def display_request_form(holding_request_type, &block)
    form_tag(holding_request_url(params[:service_response_id]), :class => "modal_dialog_form request_#{holding_request_type}" ) do
      holding_request_type_field = hidden_field_tag(:holding_request_type, holding_request_type)
      content = capture(&block)
      output = ActiveSupport::SafeBuffer.new
      output.safe_concat(content_tag(:div, holding_request_type_field, :style => 'margin:0;padding:0;display:inline'))
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

  def display_request_link_or_text(text, holding_request_type)
    (pickup_locations.length > 1) ? 
      text.html_safe :
      link_to(text, create_holding_request_url(params[:service_response_id], 
        holding_request_type, pickup_locations.first.last),
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
    count += 1 if available?
    count += 1 if recall?
    count += 1 if in_processing?
    count += 1 if on_order?
    count += 1 if offsite?
    count += 1 if ill?
    return count
  end

  # Gather and return pickup locations
  def pickup_locations
    return @pickup_locations if defined?(@pickup_locations)
    patron_status = user_permissions(@adm_library_code, @sub_library_code)[:bor_status]
    item_availability_status = 
      (@status == "Offsite Available" or @status == "Available") ? "Y" : "N"
    # Return empty pickup locations if patron status adm library or sub library
    # adm library, sub library or sub library pickup locations is nil
    return [] if patron_status.nil? or @adm_library_code.nil? or @sub_library_code.nil?
    # Get Aleph pick up locations for the given sub library
    @pickup_locations = aleph_helper.item_pickup_locations(
      :adm_library_code => @adm_library_code.downcase, :sub_library_code => @sub_library_code,
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