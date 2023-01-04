# This is based on Umlaut ResolveController from https://github.com/team-umlaut/umlaut/blob/b954895e0aa0a7cd0a9ec6bb716c1886c813601e/app/controllers/resolve_controller.rb
# This file is identical to the source file but with two methods added:
#     - calculate_url_for_response (copied from LinkRouterController - https://github.com/team-umlaut/umlaut/blob/b954895e0aa0a7cd0a9ec6bb716c1886c813601e/app/controllers/link_router_controller.rb)
#     - direct_url
# For motivation, see this comment in monday.com ticket:
#     https://nyu-lib.monday.com/boards/765008773/pulses/3386819884/posts/1897865218

# Requests to the Resolve controller are OpenURLs.
# There is one exception: Instead of an OpenURL, you can include the
# parameter umlaut.request_id=[some id] to hook up to a pre-existing
# umlaut request (that presumably was an OpenURL).
class ResolveController < UmlautController
  # These methods are meant as API called from other sites via Javascript
  # with JS responses. We don't want Rails to keep it from happening.
  # http://api.rubyonrails.org/classes/ActionController/RequestForgeryProtection.html
  skip_before_filter :verify_authenticity_token, only: [:index, :background_status, :partial_html_sections, :api]

  before_filter :init_processing

  # POST'ed OpenURLs are a mess, redirect them to GETs
  before_filter :post_to_get, :only => :index

  # Init processing will look at this list, and for actions mentioned,
  # will not create a @user_request if an existing one can't be found.
  # Used for actions meant only to deal with existing requests.
  @@no_create_request_actions = ['background_update']
  after_filter :save_request

  layout :resolve_layout, :except => [:partial_html_sections]

  def index
    # saving the bg Thread object mostly so testing environment
    # can wait on it.
    @bg_thread = self.service_dispatch()
    # check for menu skipping configuration. link is a ServiceResponse
    link = should_skip_menu
    if ( ! link.nil? )
      redirect_to url_for(:controller => "link_router",
                   :action => "index",
                   :id => link.id )
    else
      # Render configed view, if configed, or default view if not.
      render umlaut_config.resolve_view
    end
  end

  def direct_url(id)
    svc_response = ServiceResponse.find(id)

    calculate_url_for_response(svc_response)
  end
  helper_method :direct_url

  # Used to calculate a destination/target url for an Umlaut response item.
  #
  # Pass in a ServiceType join object (not actually a ServiceResponse, sorry)
  # Calculates the URL for it, and then runs our link_out_filters on it,
  # returning the final calculated url.
  #
  # Also requires a rails 'params' object, since url calculation sometimes
  # depends on submitted HTTP params.
  #
  # Used from LinkController's index,
  def calculate_url_for_response(svc_response)
    svc = ServiceStore.instantiate_service!(svc_response.service_id, nil)
    destination =  svc.response_url(svc_response, params)

    raise_missing_url!(svc_response) if destination.blank?

    # if response_url returned a string, it's an external url and we're
    # done. If it's something else, usually a hash, then pass it to
    # url_for to generate a url.
    if destination.kind_of?(String)
      url = destination

      # Call link_out_filters, if neccesary.
      # These are services listed as  task: link_out_filter  in services.yml
      (1..9).each do |priority|
        @collection.link_out_service_level( priority ).each do |filter|
          filtered_url = filter.link_out_filter(url, svc_response)
          url = filtered_url if filtered_url
        end
      end
      return url
    else
      return url_for(params_preserve_xhr(destination))
    end
  end
  protected :calculate_url_for_response

  # Return permalink for request, creating one if it doesn't already exist.
  # Usually called by AJAX, to create on-demand permalink.
  def get_permalink
    unless current_permalink_url
      permalink = Permalink.new_with_values!(@user_request.referent, @user_request.referrer_id)
      @user_request.referent.permalinks << permalink
    end

    respond_to do |format|
      format.html
      format.json do
        render :json => {:permalink => current_permalink_url}
      end
    end
  end


  # Useful for developers, generate a coins. Start from
  # search/journals?umlaut.display_coins=true
  # or search/books?umlaut.display_coins=true
  def display_coins
  end

  # Display a non-javascript background service status page--or
  # redirect back to index if we're done.
  def background_status
    unless ( @user_request.any_services_in_progress? )
      # Just redirect to ordinary index, no need to show progress status.
      # Include request.id, but also context object kev.
      params_hash =
         {:controller=>"resolve",
          :action=>'index',
          'umlaut.skip_resolve_menu'.to_sym => params['umlaut.skip_resolve_menu'],
          'umlaut.request_id'.to_sym => @user_request.id }

      url = url_for_with_co( params_hash, @user_request.to_context_object )
      redirect_to( url )
    else
      # If we fall through, we'll show the background_status view, a non-js
      # meta-refresh update on progress of background services.
      # Your layout should respect this instance var--it will if it uses
      # the resolve_head_content partial, which it should.
      @meta_refresh_self = umlaut_config.lookup!("poll_wait_seconds", 4)
    end
  end

  # This action is for external callers. An external caller _could_ get
  # data as xml or json or whatever. But Umlaut already knows how to render
  # it. What if the external caller wants the rendered content, but in
  # discrete letter packets, a packet of HTML for each ServiceTypeValue?
  # This does that, and also let's the caller know if background
  # services are still running and should be refreshed, and gives
  # the caller a URL to refresh from if neccesary.
  def partial_html_sections
    # Tell our application_helper#url_for to generate urls with hostname
    @generate_urls_with_host = true
    # Force background status to be the spinner--default js way of putting
    # spinner in does not generally work through ajax techniques.
    @force_bg_progress_spinner = true
    # Mark that we're doing a partial generation, because it might
    # matter later.
    @generating_embed_partials = true
    # Run the request if neccesary.
    self.service_dispatch()
    @user_request.save!
    self.api_render()
  end

  def api
    # Run the request if neccesary.
    self.service_dispatch()
    @user_request.save!
    api_render()
  end

  # Not an action method. Used only in test environment, get the Thread object executing
  # background services, so you can #join on it to wait for bg
  # services to complete.
  def bg_thread
    @bg_thread
  end


  protected



  def post_to_get
    if request.method == "POST"
      redirect_to url_for(params)
    end
  end

  # Retrives or sets up the relevant Umlaut Request, and returns it.
  def init_processing
    # intentionally trigger creation of session if it didn't already exist
    # because we need to track session ID for caching. Can't find any
    # way to force session creation without setting a value in session,
    # so we do this weird one.
    session[nil] = nil



    # We have to clean the params of bad char encoding bytes, or it causes
    # no end of problems later. We can't just refuse to process, sources
    # do send us bad bytes, I'm afraid.
    params.values.each do |v|
      v.scrub! if v.respond_to?(:'scrub!')
    end
    # Create an UmlautRequest object.
    options = {}
    if (  @@no_create_request_actions.include?(params[:action])  )
      options[:allow_create] = false
    end
    @user_request ||= Request.find_or_create(params, session, request, options )
    # If we chose not to create a request and still don't have one, bale out.
    return unless @user_request
    @user_request.save!
    @collection = create_collection
  end

  def save_request
    @user_request.save!
  end

  # Based on app config and context, should we skip the resolve
  # menu and deliver a 'direct' link? Returns nil if menu
  # should be displayed, or the ServiceType join object
  # that should be directly linked to.
  def should_skip_menu
    # From usabilty test, do NOT skip if coming from A-Z list/journal lookup.
    # First, is it over-ridden in url?
    if ( params['umlaut.skip_resolve_menu'] == 'false')
      return nil
    elsif ( params['umlaut.skip_resolve_menu_for_type'] )
      skip = {:service_types => params['umlaut.skip_resolve_menu_for_type'].split(",") }
    end

    # Otherwise if not from url, load from app config
    skip  ||= umlaut_config.skip_resolve_menu  if skip.nil?
    if (skip.kind_of?( FalseClass ))
      # nope
      return nil
    end
    return_value = nil
    if (skip.kind_of?(Hash) )
      # excluded rfr_ids?
      exclude_rfr_ids = skip[:excluded_rfr_ids]
      rfr_id = @user_request.referrer_id
      return nil if exclude_rfr_ids != nil && exclude_rfr_ids.find {|i| i == rfr_id}
      # Services to skip for?
      skip[:service_types].each do | service |
        service = ServiceTypeValue[service] unless service.kind_of?(ServiceTypeValue)
        return_value = @user_request.service_responses.where(:service_type_value_name => service.name).first
      end

      # But wait, make sure it's included in :services if present.
      if (return_value && skip[:services] )
        return_value = nil unless skip[:services].include?( return_value.service_id )
      end
    elsif (skip.kind_of?(Proc ))
      return_value = skip.call( :request => @user_request )
    else
      logger.error( "Unexpected value in config 'skip_resolve_menu'; assuming false." )
    end
    return return_value;
  end

  # Uses an "umlaut.response_format" param to return either
  # XML or JSON(p).  Is called from an action that has a standardly rendered
  # Rails template that delivers XML.  Will convert that standardly rendered
  # template output to json using built in converters if needed.
  def api_render
    # Format?
    request.format = "xml" if request.format.html? # weird hack to support legacy behavior, with xml as default
    if params["umlaut.response_format"] == "jsonp"
      request.format = "json"
      params["umlaut.jsonp"] ||= "umlautLoaded"
    elsif params["umlaut.response_format"]
      request.format = params["umlaut.response_format"]
    end

    respond_to do |format|
      format.xml do
        render(:layout => false)
      end

      format.json do
        # get the xml in a string
        xml_str =
          with_format(:xml) do
            render_to_string(:layout=>false)
          end
        # convert to hash. For some reason the ActionView::OutputBuffer
        # we actually have (which looks like a String but isn't exactly)
        # can't be converted to a hash, we need to really force String
        # with #to_str
        data_as_hash = Hash.from_xml( xml_str.to_str )
        # And conver to json. Ta-da!
        json_str = data_as_hash.to_json
        # Handle jsonp, deliver JSON inside a javascript function call,
        # with function name specified in parameters.
        render(:json => json_str, :callback => params["umlaut.jsonp"] )
      end
    end
  end

  def service_dispatch()
    @collection.dispatch_services!
  end
end
