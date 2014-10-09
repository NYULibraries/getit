class HoldingRequestsController < UmlautController
  # For now, a constant for the ILLiad URL
  ILLIAD_BASE_URL = (ENV['ILLIAD_BASE_URL'] || 'http://ill.library.nyu.edu')

  # E-ZBorrow URL
  EZBORROW_BASE_URL = (ENV['EZBORROW_BASE_URL'] || 'http://login.library.nyu.edu')

  # Valid holding request types
  WHITELISTED_TYPES = %w[available ill processing offsite on_order recall ezborrow]

  before_filter :restrict_access
  layout :search_layout_except_xhr

  # Show options for creating new request
  def new
    head :bad_request unless authorizer.present?
  end

  # Create a new request based on request type
  def create
    if authorizer.present?
      # Is this a valid request type?
      valid_type = whitelist_type(params[:type])
      if valid_type
        # Is the user authorized to create a request for the holding?
        if authorizer.send("#{valid_type}?".to_sym)
          if valid_type == 'ill'
            # If we're ILLing, send them to ILLiad
            redirect_to "#{ILLIAD_BASE_URL}/illiad/illiad.dll/OpenURL?#{service_response.request.to_context_object.kev}"
          elsif valid_type == 'ezborrow'
            # If we're E-ZBorrowing, send them to E-ZBorrow (via PDS)
            redirect_to "#{EZBORROW_BASE_URL}/ezborrow?query=#{holding.title}"
          else
            # Otherwise, create the hold
            create_hold = holding_request.create_hold(creation_parameters)
            unless create_hold.error?
              # Create the holding request for the current user
              redirect_to(holding_request_path(service_response, entire: entire, pickup_location: pickup_location.code))
            else
              flash[:alert] = create_hold.note
              redirect_to new_holding_request_path(service_response)
            end
          end
        else
          # If the user/item combo can't make the request
          # tell the user this is an unauthorized request
          head :unauthorized
        end
      else
        # If it's not a valid type tell the user this is a bad request
        head :bad_request
      end
    else
      head :bad_request
    end
  end

  # Show the confirmation page for the request
  def show
  end

  def scan?
    entire == 'no'
  end
  helper_method :scan?

  def pickup_location
    @pickup_location ||=
      Exlibris::Aleph::PickupLocation.new(pickup_sub_library.code, pickup_sub_library.display)
  end
  helper_method :pickup_location

  private
  def pickup_sub_library
    @pickup_sub_library ||= sub_libraries.find(->{ holding.sub_library }) do |sub_library|
      sub_library.code == params[:pickup_location]
    end
  end

  def sub_libraries
    @sub_libraries ||= tables_manager.sub_libraries
  end

  def tables_manager
    @tables_manager ||= Exlibris::Aleph::TablesManager.instance
  end

  def creation_parameters
    {
      pickup_location: pickup_location,
      sub_author: sub_author,
      sub_title: sub_title,
      pages: pages,
      note_1: note_1,
      note_2: note_2
    }
  end

  def entire
    @entire ||= params[:entire]
  end

  def sub_author
    @sub_author ||= params[:sub_author] if scan?
  end

  def sub_title
    @sub_title ||= params[:sub_title] if scan?
  end

  def pages
    @pages ||= params[:pages] if scan?
  end

  def note_1
    @note_1 ||= params[:note_1] if scan?
  end

  def note_2
    @note_2 ||= begin
      if scan?
        'User requested a scan'
      else
        'User requested the entire item'
      end
    end
  end

  def authorizer
    if holding_request.present?
      @authorizer ||= HoldingRequest::Authorizer.new(holding_request)
    end
  end

  def holding_request
    if holding.present?
      @holding_request ||= HoldingRequest.new(holding, current_user)
    end
  end

  def holding
    if service_response.present?
      @holding ||= GetIt::HoldingManager.new(service_response).holding
    end
  end

  # Return the service response or nil if the record is not found
  def service_response
    @service_response ||= ServiceResponse.find(params[:service_response_id])
  rescue ActiveRecord::RecordNotFound
    nil
  end

  # Restrict access to logged in users.
  def restrict_access
    head :unauthorized and return false unless current_user
  end

  # Whitelist the holding request type
  def whitelist_type(candidate)
    WHITELISTED_TYPES.find{ |type| type == candidate }
  end
end
