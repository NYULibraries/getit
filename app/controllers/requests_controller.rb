class RequestsController < UmlautController
  before_filter :restrict_access, :init
  layout :search_layout_except_xhr

  attr_reader :status, :status_code, :adm_library_code, :sub_library_code, :original_source_id,
    :source_record_id, :item_id, :item_status_code, :item_process_status_code, :circulation_status,
      :illiad_url, :aleph_rest_url, :ill_url, :pickup_location, :note_2, :request_type

  helper_method :status, :status_code, :adm_library_code, :sub_library_code, :original_source_id, 
    :source_record_id, :item_id, :item_status_code, :item_process_status_code, :circulation_status,
     :illiad_url, :aleph_rest_url, :ill_url, :pickup_location, :note_2, :request_type

  # Initialize the instance variables needed in
  # the controller
  def init
    @service_response = ServiceResponse.find(params[:service_response_id])
    @view_data = @service_response.view_data if @service_response
    @user_request = @service_response.request if @service_response
    @original_source_id = @view_data[:original_source_id]
    request_instance_attributes_set @view_data[:source_data]
    @illiad_url = @view_data[:source_data][:illiad_url]
    @aleph_rest_url = @view_data[:source_data][:aleph_rest_url]
    @ill_url = "#{illiad_url}/illiad/illiad.dll/OpenURL?#{@user_request.to_context_object.kev}"
  end

  # Create a new request based on request type
  def create
    @request_type = params[:request_type]
    @scan = (params.fetch(:entire, "yes") == "no") ? true : false
    @pickup_location = params.fetch(:pickup_location, sub_library_code)
    # Set note_2 as entire_yes/entire_no
    @note_2 = (scan?) ? "entire_no" : "entire_yes"
    # Is this a valid request type?
    if request_types.include?(request_type)
      # Can the user/item combo make the request
      if send("request_#{request_type}?".to_sym)
        if request_type.eql? "ill"
          redirect_to ill_url
        else
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
    begin
      patron.place_hold(adm_library_code, original_source_id, source_record_id, 
        item_id, {:pickup_location => pickup_location, :note_2 => note_2})
      redirect_to(request_path(params[:service_response_id], :scan => scan?, 
        :pickup_location => pickup_location))
    # rescue VCR::Errors::UnhandledHTTPRequestError => e
    #   raise e
    rescue
      flash[:alert] = patron.error
      redirect_to new_request_path(params[:service_response_id])
    end
  end
  private :create_aleph_request

  # Aleph Patron for placing holds
  def patron
    @patron ||= Exlibris::Aleph::Patron.new(current_user.user_attributes[:nyuidn], aleph_rest_url)
  end
  private :patron
end