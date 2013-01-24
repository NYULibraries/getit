class RequestsController < UmlautController
  before_filter :require_login, :init

  layout Proc.new { |controller|
    if (controller.request.xhr? ||
        controller.params["X-Requested-With"] == "XmlHttpRequest")
      nil
    else
      config.search_layout
    end
  }

  attr_reader :status, :status_code, :adm_library_code, :sub_library_code, :source_record_id,
    :item_id, :item_status_code, :item_process_status_code, :circulation_status,
      :illiad_url, :aleph_rest_url, :ill_url, :pickup_location, :request_type

  helper_method :status, :status_code, :adm_library_code, :sub_library_code, :source_record_id,
    :item_id, :item_status_code, :item_process_status_code, :circulation_status,
     :illiad_url, :aleph_rest_url, :ill_url, :pickup_location, :request_type

  def init
    @service_response = ServiceResponse.find(params[:service_response_id])
    @view_data = @service_response.view_data if @service_response
    @user_request = @service_response.request if @service_response
    request_instance_attributes_set @view_data[:source_data]
    @illiad_url = @view_data[:source_data][:illiad_url]
    @aleph_rest_url = @view_data[:source_data][:aleph_rest_url]
    @ill_url = "#{illiad_url}/illiad/illiad.dll/OpenURL?#{@user_request.to_context_object.kev}"
  end

  # Create a new request based on request type
  def create
    @request_type = params[:request_type]
    @scan = (params.fetch(:entire, "yes") == "no") ? true : false
    @pickup_location = params.fetch(:pickup_location, "")
    # Set note_2 as entire_yes/entire_no
    params[:note_2] = (scan?) ? "entire_no" : "entire_yes"
    if request_types.include?(request_type)
      if send("request_#{request_type}?".to_sym, @view_data)
        if request_type.eql? "ill"
          redirect_to ill_url
        else
          create_aleph_request
        end
      else
        redirect_to new_request_path(params[:service_response_id]), 
          :flash => { :alert => permission_error }
      end
    else
      redirect_to new_request_path(params[:service_response_id]), 
        :flash => { :alert => unexpected_error }
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

  # Create an Aleph request
  def create_aleph_request
    begin
      patron.place_hold(adm_library_code, sub_library_code, source_record_id, 
        item_id, {:pickup_location => pickup_location})
      respond_to do |format|
        redirect_to request_path(params[:service_response_id], :scan => scan?, 
          :pickup_location => pickup_location)
      end
    rescue Exception => e
      if patron.error.nil?
        flash[:alert] = unexpected_error
      else
        flash[:alert] = patron.error
      end
      redirect_to new_request_path(params[:service_response_id])
    end
  end
  private :create_aleph_request

  # Aleph Patron for placing holds
  def patron
    Exlibris::Aleph::Patron.new(current_user.user_attributes[:nyuidn], aleph_rest_url)
  end
  private :patron
end