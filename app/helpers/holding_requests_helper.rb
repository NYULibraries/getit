module HoldingRequestsHelper

  # Display title for the holding request
  def title
    @title ||= HoldingRequest::Title.new(@holding_request)
  end

  # Options available for the holding request
  def options
    @options ||= HoldingRequest::Options.new(@holding_request)
  end

  # Pickup locations for the holding request
  def pickup_locations
    @pickup_locations ||= HoldingRequest::PickupLocations.new(@holding_request)
  end

  # Request form to offer holding request options
  def request_form(type, &block)
    url = holding_request_url(service_response)
    form_tag(url, id: "holding-request-#{type}", class: 'modal_dialog_form') do
      type_field = hidden_field_tag(:type, type)
      content = capture(&block)
      output = ActiveSupport::SafeBuffer.new
      style = 'margin:0;padding:0;display:inline'
      output.safe_concat(content_tag(:div, type_field, style: style))
      output << content
    end
  end

  # Request option for a request form
  def request_option(type, &block)
    content_tag(:li, id: "holding-request-option-#{type}") do
      content_tag(:div, class: 'section') do
        yield
      end
    end
  end

  # Request a scan of a portion of the item option (with radio button).
  def request_link_or_text(text, type)
    if (pickup_locations.size > 1)
      text.html_safe
    else
      content_tag(:p) do
        options = {target: '_blank', class: 'ajax_window'}
        link_to_create_holding_request(text, type, options)
      end
    end
  end

  # Request option the entire item (with radio button).
  # Request for the entire item to be delivered to a pickup location
  def entire_request_option(type)
    request_option("#{type}-entire") do
      label_tag(:entire_yes, class: 'radio') do
        radio_button_tag('entire',  'yes', checked: true) +
        t("holding_requests.new.#{type}.entire.default") +
        delivery_times
      end + pickup_locations_field_set(style: 'padding-left: 20px;')
    end
  end

  # Request option for a scanned of a portion of the item (with radio button).
  # Request for a portion of the item to scanned and delivered electronically.
  def scan_request_option(type)
    request_option("#{type}-scan") do
      label_tag(:entire_no, class: 'radio') do
        radio_button_tag('entire',  'no') +
        t("holding_requests.new.#{type}.scan.default") +
        fair_use_disclaimer
      end + scan_field_set(style: 'padding-left: 20px;padding-right: 20px;')
    end
  end

  # Pickup locations fields for an item request
  # If there are multiple pickup locations, a select box is rendered.
  # If there is only one pickup location, text specifying the pickup
  # location with a hidden field is rendered.
  def pickup_locations_field_set(field_set_options=nil)
    field_set_tag(nil, field_set_options) do
      if pickup_locations.size > 1
        label_tag('pickup_location', 'Select pickup location:') +
         select_tag('pickup_location', options_for_select(pickup_locations.to_a))
      else
        pickup_location = begin
          if pickup_locations.size == 1
            pickup_locations.first
          else
            holding.sub_library
          end
        end
        content_tag(:strong, "Pickup location is #{pickup_location.display}.") +
          hidden_field_tag('pickup_location', pickup_location.code)
      end
    end
  end

  # Scan fields for the scanned portion request option.
  # Fields include
  #   - Author of Part
  #   - Title of Part
  #   - Desired pages
  #   - Notes
  def scan_field_set(field_set_options=nil)
    field_set_tag(nil, field_set_options) do
      label_tag("sub_author", "Author of part:", class: "control-label") +
        text_field_tag("sub_author", nil, class: "form-control") +
      label_tag("sub_title", "Title of part:", class: "control-label") +
        text_field_tag("sub_title", nil, class: "form-control") +
      label_tag("pages", "Pages (e.g., 7-12; 5, 6-8, 10-15):", class: "control-label") +
        text_field_tag("pages", nil, class: "form-control") +
      label_tag("note_1", "Notes:", class: "control-label") +
        text_field_tag("note_1", nil, maxlength: 50, class: "form-control")
    end
  end

  # Expected delivery times.
  # Provide a link to the delivery times that patrons can expect
  # for the request.
  # Only display delivery times if mulitple pickup locations
  def delivery_times
    if pickup_locations.size > 1
      content_tag(:p, link_to_delivery_times, class: "delivery-times")
    end
  end

  # Fair user disclaimer for scanned resources.
  # Provide a link to fair use guidelines
  def fair_use_disclaimer
    content_tag(:p, class: "fair-use-disclaimer") do
      '(Requests must be within '.html_safe +
      link_to_fair_use_guidelines + '.)'.html_safe
    end
  end

  # Help for delivery choices.
  # Provide a link to helpful information explaining
  # the various choices if there are multiple choices
  def delivery_help
    if options.size > 1
      content_tag(:p, link_to_delivery_help, class: 'delivery-help')
    end
  end

  # Link to create a holding request for the given type with the given text
  def link_to_create_holding_request(text, type, options)
    pickup_location = (pickup_locations.first || holding.sub_library)
    url = create_holding_request_url(service_response, type, pickup_location.code)
    link_to(text, url, options)
  end

  # Delivery times link
  def link_to_delivery_times
    url = 'http://library.nyu.edu/services/deliveryservices.html#how_long'
    link_to('See delivery times', url, target: '_blank')
  end

  # Fair use link
  def link_to_fair_use_guidelines
    url = 'http://library.nyu.edu/copyright/#fairuse'
    link_to('fair use guidelines', url, target: "_blank")
  end

  # Delivery help link
  def link_to_delivery_help
    link_to('http://library.nyu.edu/help/requesthelp.html', target: '_blank') do
      icon_tag(:info) + content_tag(:span, 'Not sure which option to choose?')
    end
  end

  def available_request_text
    @available_request_text ||= begin
      case holding.sub_library.code
      when 'NABUD', 'NADEX'
        t('holding_requests.new.available.entire.nyuad')
      when 'BAFC'
        t('holding_requests.new.available.entire.afc')
      else
        t('holding_requests.new.available.entire.default')
      end
    end
  end

  def success_text
    @success_text ||= begin
      if (scan?)
        t('holding_requests.show.scan')
      else
        t('holding_requests.show.default', pickup_location: "#{pickup_location.display}")
      end
    end
  end

  def service_response
    holding.service_response unless holding.nil?
  end

  def holding
    @holding_request.holding unless @holding_request.nil?
  end
end
