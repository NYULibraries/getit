class HoldingRequestsController < UmlautController
  # For now, a constanst for the ILLiad URL
  ILLIAD_URL = Settings.urls.ill

  # Valid holding request types
  WHITELISTED_HOLDING_REQUEST_TYPES = ["available", "ill", "in_processing", "offsite", "on_order", "recall"]

  before_filter :restrict_access
  layout :search_layout_except_xhr

  # Show options for creating new request
  def new
    @service_response_id = params[:service_response_id]
    if service_response.present?
      # Instaniate the holding from the service response
      @holding = Holding.new(service_response)
      # Instantiate the holding request authorizer
      @authorizer = Policies::HoldingRequestAuthorizer.new(@holding, current_user)
      # Original user request for title citation
      @user_request = service_response.request
    end
  end

  # Create a new request based on request type
  def create
    @service_response_id = params[:service_response_id]
    if service_response.present?
      # Instaniate the holding from the service response
      @holding = Holding.new(service_response)
      # Instantiate the holding request authorizer
      @authorizer = Policies::HoldingRequestAuthorizer.new(@holding, current_user)
      # Original user request for ILL context object
      @user_request = service_response.request
      # Is this a valid request type?
      valid_holding_request_type = whitelist_holding_request_type(params[:holding_request_type])
      # Are we doing a scan?
      @scan = params.fetch(:entire, "yes").to_s.eql?("no")
      # Get the pickup location if sent, otherwise set it from the holding
      @pickup_location = params.fetch(:pickup_location, @holding.sub_library_code)
      # Set note_2 as entire_yes/entire_no
      @note_2 = (@scan) ? "entire_no" : "entire_yes"
      if @scan
        @sub_author = params[:sub_author].to_s
        @sub_title = params[:sub_title].to_s
        @pages = params[:pages].to_s
        @note_1 = params[:note_1].to_s
      end
      if valid_holding_request_type
        # Can the user/item combo make the request
        if @authorizer.send("#{valid_holding_request_type}?".to_sym)
          if valid_holding_request_type.eql? "ill"
            # If we're ILLing, send them to ILLiad
            redirect_to "#{ill_url}/illiad/illiad.dll/OpenURL?#{@user_request.to_context_object.kev}"
          else
            # Otherwise, create a hold
            begin
              hold_options = { pickup_location: @pickup_location, sub_author: @sub_author,
                sub_title: @sub_title, pages: @pages, note_1: @note_1, note_2: @note_2 }
              # Create the hold for the current user
              current_user.create_hold(@holding, hold_options)
              redirect_to(holding_request_path(service_response, scan: @scan, pickup_location: @pickup_location))
            rescue
              flash[:alert] = current_user.error
              redirect_to new_holding_request_path(service_response)
            end
          end
        else
          # If the user/item combo can't make the request
          # tell the user this is an unauthorized request
          head :unauthorized
        end
      else
        # If not valid request type
        # tell the user this is a bad request
        head :bad_request
      end
    else
      head :bad_request
    end
  end

  # Show the confirmation page for the request
  def show
    @scan = params.fetch(:scan, "false").eql?("true")
    @pickup_location = params.fetch(:pickup_location, "")
  end

  # Return the service response
  def service_response
    # Get the service response
    @service_response ||= ServiceResponse.find(@service_response_id)
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "We're very sorry. Something went wrong. Please refresh the page and make your request again."
    @service_response = nil
  end
  private :service_response

  # Restrict access to logged in users.
  def restrict_access
    head :unauthorized and return false unless current_user
  end
  private :restrict_access

  # Whitelist the holding request type
  def whitelist_holding_request_type(candidate)
    WHITELISTED_HOLDING_REQUEST_TYPES.find{ |holding_request_type| holding_request_type == candidate }
  end
  private :whitelist_holding_request_type

  def ill_url
    return ILLIAD_URL
    # @ill_url ||= current_primary_institution.views["ill"]["url"]
  end
  private :ill_url
end
