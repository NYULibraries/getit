class HoldingRequestsController < UmlautController
  # Valid holding request types
  WHITELISTED_HOLDING_REQUEST_TYPES = ["available", "ill", "in_processing", "offsite", "on_order", "recall"]

  before_filter :restrict_access, :init
  layout :search_layout_except_xhr

  # Initialize the instance variables needed in
  # the controller
  def init
    @service_response = ServiceResponse.find(params[:service_response_id])
    @view_data = @service_response.view_data if @service_response
    @user_request = @service_response.request if @service_response
    @original_source_id = @view_data[:original_source_id]
    @status = @view_data[:status]
    @status_code = @view_data[:status_code]
    @requestability = @view_data[:requestability]
    source_data = @view_data[:source_data]
    @adm_library_code = source_data[:adm_library_code]
    @sub_library_code = source_data[:sub_library_code]
    @sub_library = source_data[:sub_library]
    @item_status_code = source_data[:item_status_code]
    @item_process_status_code = source_data[:item_process_status_code]
    @source_record_id = source_data[:source_record_id]
    @item_id = source_data[:item_id]
    @illiad_url = source_data[:illiad_url]
    @aleph_rest_url = source_data[:aleph_rest_url]
  end

  # Create a new request based on request type
  def create
    # Is this a valid request type?
    valid_holding_request_type = whitelist_holding_request_type(params[:holding_request_type])
    @scan = params.fetch(:entire, "yes").to_s.eql?("no")
    @pickup_location = params.fetch(:pickup_location, @sub_library_code)
    # Set note_2 as entire_yes/entire_no
    @note_2 = (scan?) ? "entire_no" : "entire_yes"
    if scan?
      @sub_author = params[:sub_author].to_s
      @sub_title = params[:sub_author].to_s
      @pages = params[:pages].to_s
      @note_1 = params[:note_1].to_s
    end
    if valid_holding_request_type
      # Can the user/item combo make the request
      if send("#{valid_holding_request_type}?".to_sym)
        if valid_holding_request_type.eql? "ill"
          # If we're ILLing, send them to ILLiad
          redirect_to "#{@illiad_url}/illiad/illiad.dll/OpenURL?#{@user_request.to_context_object.kev}"
        else
          # Otherwise, create an Aleph request
          create_aleph_request
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
  end

  # Show the confirmation page for the request
  def show
    @scan = params.fetch(:scan, false)
    @pickup_location = params.fetch(:pickup_location, "")
  end

  def scan?
    @scan
  end
  helper_method :scan?

  # Restrict access to logged in users.
  def restrict_access
    head :unauthorized and return false unless current_user
  end
  private :restrict_access

  # Create an Aleph request
  def create_aleph_request
    patron.place_hold(@adm_library_code, @original_source_id, @source_record_id, 
      @item_id, { :pickup_location => @pickup_location, 
        :sub_author => @sub_author, :sub_title => @sub_title,
          :pages => @pages, :note_1 => @note_1, :note_2 => @note_2 })
    redirect_to(holding_request_path(params[:service_response_id], :scan => @scan, 
      :pickup_location => @pickup_location))
  rescue
    flash[:alert] = patron.error
    redirect_to new_holding_request_path(params[:service_response_id])
  end
  private :create_aleph_request

  # Aleph Patron for placing holds
  def patron
    @patron ||= Exlibris::Aleph::Patron.new(patron_id: current_user.user_attributes[:nyuidn])
  end
  private :patron

  # Whitelist the holding request type
  def whitelist_holding_request_type(candidate)
    WHITELISTED_HOLDING_REQUEST_TYPES.find{ |holding_request_type| holding_request_type == candidate }
  end
  private :whitelist_holding_request_type
end
