module RequestsHelper
  # Constants for 'requestability' value.
  RequestableYes = 'yes'
  RequestableDeferred = 'deferred'
  RequestableNo = 'no'
  RequestableUnknown = 'unknown'
  # Define various configuration options
  @@request_types = ["available", "ill", "in_processing", "offsite", "on_order", "recall"]
  @@requestable_available_states = { :status => ["Available"] }
  @@requestable_offsite_states = { :status => ["Offsite Available"] }
  @@requestable_in_processing_states = { :status => ["In Processing", "In Transit"] }
  @@requestable_on_order_states = { :status => ["On Order"] }
  @@requestable_recall_states = { :status => ["Requested"], :status_code => ["checked_out"] }
  @@requestable_ill_states = {
    :status => ["Request ILL", "Requested", "On Order", "In Processing", "In Transit"],
    :status_code => ["checked_out", "billed_as_lost"] }

  # Creates instance methods for the defined request types based on the class 
  # methods of the same name, with the current @view_data instance variable
  # and current_user_session as the arguments.
  def self.included(klass)
    @@request_types.each do |type|
      klass.send(:define_method, "request_#{type}?") {
        RequestsHelper.send("request_#{type}?".to_sym, @view_data, current_user_session)
      }
    end
  end

  # Returns types that are requestable
  def self.request_types
    @@request_types
  end
  
  # Returns a boolean indicating whether a request link should be displayed
  # for the given view data and user session.
  # Conditions for request link are:
  # ILL OR available OR recall OR in processing OR on_order OR offsite
  def self.link_to_request?(view_data, user_session)
		return  (request_ill?(view_data, user_session) or 
      request_available?(view_data, user_session) or 
      request_recall?(view_data, user_session) or 
      request_in_processing?(view_data, user_session) or 
      request_on_order?(view_data, user_session) or 
      request_offsite?(view_data, user_session))
	end

  # Returns a boolean indicating whether the the given view data
  # is available and requestable for the given user session
  def self.request_available?(view_data, user_session)
    return requestable?(
      view_data, 
      @@requestable_available_states, 
      user_session, 
      { :hold_on_shelf => "Y", :hold_permission => "Y" } )
  end

  def self.request_recall?(view_data, user_session)
    return requestable?(
      view_data, 
      @@requestable_recall_states, 
      user_session, 
      {:hold_permission => "Y"} )
  end

  def self.request_in_processing?(view_data, user_session)
    return requestable?(
      view_data, 
      @@requestable_in_processing_states, 
      user_session, 
      {:hold_permission => "Y"} )
  end

  def self.request_offsite?(view_data, user_session)
    return requestable?(
      view_data, 
      @@requestable_offsite_states, 
      user_session, 
      {:hold_permission => "Y"} )
  end

  def self.request_on_order?(view_data, user_session)
    return requestable?(
      view_data, 
      @@requestable_on_order_states, 
      user_session, 
      {:hold_permission => "Y"} )
  end

  # We don't care about user permissions when we're dealing with ILL.
  def self.request_ill?(view_data, user_session)
    return item_state_requestable?(view_data, @@requestable_ill_states)
  end
  
  # We need to determine if the item state is valid for the type of request we're trying to make (e.g. recall, offsite)
  # We need to determine if the user's permissions are in a state that
  # is valid for the type of request we're trying to make (e.g. recall, offsite)
  # In order to determine which state we are in we need a combination of 
  #   1. item data and requestable states for that item data
  #   2. current user permissions and requestable states for those user permissions
  def self.requestable?(item, item_requestable_states, user_session, user_permissions_requestable_states)
    # Determine if the item is in a requestable state for the type of request we're making.
    return false unless item_state_requestable?(item, item_requestable_states)
    # If always requestable, we can return true if user session is nil
    return true if (item_requestability(item).eql?(RequestableYes) and user_session.nil?)
    # TODO: Abstract out deferral logic.
    user_permissions_for_item = user_permissions_for_item(user_session, item)
    return (item_requestable?(item) and 
      user_permissions_state_requestable?(user_permissions_for_item, user_permissions_requestable_states))
  end
  
  def self.item_requestable?(item)
    return [RequestableYes, RequestableDeferred].include?(item_requestability(item))
  end
  
  # TODO: The two functions below are completely inconsistent and need to 
  # abstacted out to fix the inconsistencies.
  # Indicates whether the item is in a requestable state
  # This is an OR test.
  def self.item_state_requestable?(item, requestable_states={})
    requestable_states.each_pair { |data_key, requestable_values|
      return true if requestable_values.include?(item[data_key])
    }
    return false
  end
  
  # Indicates whether the user permissions are in a requestable state
  # This is an AND test.
  def self.user_permissions_state_requestable?(user_permissions, requestable_states={})
    requestable_states.each_pair { |data_key, requestable_value|
      return false unless requestable_value.eql?(user_permissions[data_key])
    }
    return true
  end
  
  # There are three states of requestability for an item
  #   1. The item is requestable
  #   2. The item is sometimes requestable, but the decision is deferred to another decider
  #   3. The item is not requestable
  def self.item_requestability(item)
    # TODO: Make this configurable per item type (e.g. Aleph, SomeOtherTrickedOutSystem)
    aleph_item_requestability(item)
  end
  
  def self.user_permissions_for_item(user_session, item)
    # TODO: Make this configurable per item type (e.g. Aleph, SomeOtherTrickedOutSystem)
    aleph_user_permissions_for_item(user_session, item)
  end
  
  # Aleph methods
  def self.aleph_helper
    Exlibris::Aleph::TabHelper.instance()
  end

  # TODO: Abstract out Aleph methods
  def self.aleph_item_requestability(item={})
    # TODO: Move this into the AlephHelper
    aleph_nonrequestable_circ_statuses = ["Reshelving"]
    aleph_requestable_item_hold_values = ["C"]
    aleph_requestable_ill_values = ["Y"]
    aleph_user_requestable_item_hold_values = ["Y"]
    aleph_item = item[:source_data]
    return RequestableUnknown if aleph_item.nil?
    # Handle Non-Requestable Circ Statuses
    return RequestableNo if aleph_nonrequestable_circ_statuses.include?(aleph_item[:aleph_item_circulation_status])
    # Check item permissions
    aleph_item_permissions = aleph_item_permissions(item)
    # TODO: Abstract out the item permissions stuff.
    return RequestableYes if (aleph_requestable_item_hold_values.include?(aleph_item_permissions[:hold_request]) or 
      aleph_requestable_ill_values.include?(aleph_item_permissions[:photocopy_request]))
    return RequestableDeferred if aleph_user_requestable_item_hold_values.include?(aleph_item_permissions[:hold_request])
    return RequestableNo
  end

  def self.aleph_item_permissions(item={})
    aleph_item = item[:source_data]
    return {} if aleph_item.nil? or aleph_item[:aleph_item_adm_library].nil?
    return aleph_helper.item_permissions(
      :adm_library_code => aleph_item[:aleph_item_adm_library].downcase,
      :sub_library_code => aleph_item[:aleph_item_sub_library_code],
      :item_status_code => aleph_item[:aleph_item_status_code],
      :item_process_status_code => aleph_item[:aleph_item_process_status_code] ) 
  end
  
  def self.aleph_user_permissions_for_item(user_session, item={})
    aleph_item = item[:source_data]
    return {} if user_session.nil? or aleph_item.nil?
    current_user = user_session.user
    aleph_item_sub_library_code = aleph_item[:aleph_item_sub_library_code]
    # Set aleph user permissions for this item if they're already in the DB.
    aleph_user_permissions = current_user.user_attributes[:aleph_permissions]
    aleph_user_permissions_for_item = aleph_user_permissions[aleph_item_sub_library_code] unless aleph_user_permissions.nil?
    # Get the user permissions from Aleph if they're not in the DB.
    if aleph_user_permissions_for_item.nil?
      current_user.user_attributes[:aleph_permissions][aleph_item_sub_library_code] = 
        user_session.aleph_bor_auth_permissions(
          current_user.user_attributes[:nyuidn],
          current_user.user_attributes[:verification],
          aleph_item[:aleph_item_adm_library],
          aleph_item_sub_library_code)
      current_user.save_without_session_maintenance
      aleph_user_permissions_for_item = current_user.user_attributes[:aleph_permissions][aleph_item_sub_library_code]
    end
    Rails.logger.error(
        "Error in #{self.class}. "+ 
        "Aleph patron permissions not found for user '#{current_user.username}', at sub library '#{@aleph_item_sub_library_code}'"
      ) if aleph_user_permissions_for_item.nil?
    return (aleph_user_permissions_for_item.nil?) ? {} : aleph_user_permissions_for_item
  end

  def self.permission_error
    rv = ""
    rv += "<div class=\"validation_errors\">\n"
    rv += "\t<span>You do not have permission to perform this request.  Please contact <a href=\"mailto:access.services@nyu.edu\">access.services@nyu.edu</a> for further information.</span>\n"
    rv += "</div>\n"
    return rv
  end

  def self.unexpected_error
    rv = ""
    rv += "<div class=\"validation_errors\">\n"
    rv += "\t<span>An unexpected error has occurred.  Please contact <a href=\"mailto:web.services@librarynyu.edu\">web.services@library.nyu.edu</a> to address this issue.</span>\n"
    rv += "</div>\n"
    return rv
  end

  # Display header for the given title
  def display_header(title)
    return "<strong>\"#{title}\"</strong> is requested." if @view_data[:status].match(/Requested/)
    return "<strong>\"#{title}\"</strong> is checked out." if request_recall?
    return "<strong>\"#{title}\"</strong> is available at #{@view_data[:library]}." if request_available?
    return "<strong>\"#{title}\"</strong> is available from the #{@view_data[:library]} offsite storage facility." if request_offsite?
    return "<strong>\"#{title}\"</strong> is currently being processed by library staff." if request_in_processing?
    return "<strong>\"#{title}\"</strong> is on order." if request_on_order?
    return "<strong>\"#{title}\"</strong> is currently out of circulation." if request_ill?
  end

  # Display 'available' request options
  def display_available
    nyu_sub_libraries = ["BOBST", "NCOUR"]
    ad_sub_libraries = ["NABUD", "NADEX"]
    afc_sub_libraries = ["BAFC"]
    available_display = "\t<li>\n"
    available_display += "\t\t<div class=\"section\">\n"
    if (nyu_sub_libraries.include?(@aleph_item_sub_library_code))
      available_display += "\t\t\t" + radio_button_tag("entire",  "yes", :checked => true) + "\n"
      available_display += "\t\t\tRequest this item to be delivered to an NYU Library of your choice.<br />\n"
      available_display += "\t\t\t" + display_pickup_locations + "\n"
      available_display += "\t\t\t" + display_delivery_times_link + "\n"
      available_display += "\t\t</div>\n"
      available_display += "\t</li>\n" 
      available_display += "\t<li>\n"
      available_display += "\t\t<div class=\"section\">\n"
      available_display += "\t\t\t" + radio_button_tag("entire",  "no") + "\n"
      available_display += "\t\t\tRequest that portions of the item be scanned and delivered electronically.\n"
      available_display += "\t\t\t(Requests must be within <a href=\"http://library.nyu.edu/copyright/#fairuse\" target=\"_blank\">fair use guidelines</a>.)<br /><br />\n"
      available_display += "\t\t\t" + display_scan_elements + "\n"
    else
      if (afc_sub_libraries.include?(@aleph_item_sub_library_code))
        available_display += "\t\t\tRequest this item for pick up at the Avery Fisher Center on the 2nd floor of the Bobst Library (NYC) or the NYU Abu Dhabi Library (UAE).<br />\n"
      elsif (ad_sub_libraries.include?(@aleph_item_sub_library_code))
        available_display += "\t\t\tRequest this item.\n"
			  available_display += "\t\t\tIt will be held for you at the specified pickup location.\n"
			  available_display += "\t\t\tItems are ready for pickup within 2 business days.<br />\n"
      else
        available_display += "\t\t\tRequest this item to be delivered to the pickup location of your choice.<br />\n"
      end
      available_display += "\t\t\t" + display_pickup_locations + "\n"
      available_display += "\t\t\t" + display_delivery_times_link + "\n"
    end
    available_display += "\t\t</div>\n"
    available_display += "\t</li>\n"
  	available_display += "\t#{submit_tag('Submit')}\n"
    return available_display
  end

  # Display 'recall' request options
  def display_recall
    recall_display = ""
    recall_display +=  (@view_data[:status].match(/Requested/)) ? 
      display_recall_requested : display_recall_regular
  	recall_display += "\t\t\t#{display_pickup_locations}\n"
  	recall_display += "\t\t\t#{display_delivery_times_link}\n"
  	recall_display += "\t\t\t#{submit_tag('Submit') if pickup_locations.length > 1}\n"
    return recall_display
  end

  # Display 'recall' request options under normal conditions
  def display_recall_regular
    recall_regular_display = ""
    if (pickup_locations.length == 1)
		  recall_regular_display += "\t\t\t#{link_to(
				"Recall this item from a fellow library user", 
				{:controller => 'requests', :action=>"send_recall_request", :id=>params[:id], :pickup_location => pickup_locations.first.last},
				{:target => "_blank", :class => "ajax_window"})}.<br />\n"
		elsif pickup_locations.length > 1
			recall_regular_display += "\t\t\tRecall this item from a fellow library user.\n"
	  end
    afc_sub_libraries = ["BAFC"]
    recall_date = (afc_sub_libraries.include?(@aleph_item_sub_library_code)) ? "1 week" : "2 weeks"
    recall_regular_display += "\t\t\tThe item will be available within #{recall_date}.<br />\n"
    return recall_regular_display
  end
  
  # Display 'recall' request options if the item is requested
  def display_recall_requested
    recall_requested_display = "\t\t\tThis material has been requested by a fellow library user.\n"
    if (pickup_locations.length == 1)
		  recall_requested_display += "\t\t\t#{link_to(
				"You may also place a request to be added to the queue", 
				{:controller => 'requests', :action=>"send_recall_request", :id=>params[:id], :pickup_location => pickup_locations.first.last},
				{:target => "_blank", :class => "ajax_window"})}.<br />\n"
		elsif pickup_locations.length > 1
			recall_requested_display += "\t\t\tYou may also place a request to be added to the queue.<br />\n"
	  end
    return recall_requested_display
  end

  # Display pickup locations
  def display_pickup_locations
    return (pickup_locations.length > 1) ?
      "#{label("pickup_location", "Select pickup location:")} #{select_tag('pickup_location', options_for_select(pickup_locations))}\n" : 
      (pickup_locations.length == 1) ?
        "<strong>Pickup location is #{pickup_locations.first.first}</strong>#{hidden_field_tag("pickup_location", pickup_locations.first.last)}\n" :
        "<strong>Pickup location is #{decode_sub_library(@aleph_item_sub_library_code)}</strong>#{hidden_field_tag("pickup_location", @aleph_item_sub_library_code)}\n"
  end
  
  # Display delivery times link
  def display_delivery_times_link
    return (pickup_locations.length > 1) ? 
      "<div>(<a href=\"http://library.nyu.edu/services/deliveryservices.html\" target=\"_blank\">See delivery times</a>)</div>\n" : ""
  end
  
  # Display delivery help link
  def display_delivery_help_link
    return (request_option_count > 1) ? 
      "<p style=\"margin-top: 1em;\"><a class=\"nyulibrary_icons_information\" href=\"http://library.nyu.edu/help/requesthelp.html\" target=\"_blank\">Not sure which option to choose?</a></p>\n" : ""
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
    patron_status = RequestsHelper.user_permissions_for_item(current_user_session, @view_data)[:bor_status]
    item_availability_status = (@view_data[:status] == "Offsite Available" or 
      @view_data[:status] == "Available") ? "Y" : "N"
    # Return empty pickup locations is any of patron permissions, adm library, sub library or sub library pickup locations is nil
    return [] if patron_status.nil? or @aleph_item_adm_library.nil?
    # Get Aleph pick up locations for the given sub library
    item_pickup_locations = RequestsHelper.aleph_helper.item_pickup_locations(
      :adm_library_code => @aleph_item_adm_library.downcase,
      :sub_library_code => @aleph_item_sub_library_code,
      :item_status_code => @aleph_item_status_code,
      :item_process_status_code => @aleph_item_process_status_code,
      :bor_status => patron_status,
      :availability_status => item_availability_status
    ) unless @aleph_item_adm_library.nil?
    @pickup_locations = (item_pickup_locations.nil?) ? 
      [[decode_sub_library(@aleph_item_sub_library_code), @aleph_item_sub_library_code]] : item_pickup_locations.collect { |location_code| 
        [decode_sub_library(location_code), location_code]
      }
    return @pickup_locations
  end

  # Display scan elements
  def display_scan_elements
    rv = ""
    rv += label("sub_author", "Author of part:") + "\n"
    rv += text_field_tag("sub_author") + "<br />"
    rv += label("sub_title", "Title of part:") + "\n"
    rv += text_field_tag("sub_title") + "<br />"
    rv += label("pages", "Pages (e.g., 7-12; 5, 6-8, 10-15):") + "\n"
    rv += text_field_tag("pages") + "<br />"
    rv += label("note_1", "Notes:") + "\n"
    rv += text_field_tag("note_1", nil, :maxlength => 50) + "<br />"
    return rv
  end

  # Display request confirmation
  def display_request_confirmation
    return "Your request has been processed. You will be notified when this item is available to pick up at #{decode_sub_library(@pickup_location)}." unless @is_scan
    return "Your scan request has been processed. You will receive an email when the item is available." if @is_scan
  end

  # Decode sublibrary
  def decode_sub_library(code)
    value = RequestsHelper.aleph_helper.sub_library_text(code)
    return (value.nil?) ? code : value
  end
end