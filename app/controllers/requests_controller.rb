class RequestsController < UmlautController
  before_filter :load_objects
  layout Proc.new { |controller|         
    if (controller.request.xhr? ||
        controller.params["X-Requested-With"] == "XmlHttpRequest")
      nil
    else
      config.search_layout
    end
  }

  def load_objects
    @svc_type = ServiceResponse.find(params[:id])
    @view_data = @svc_type.view_data
    # Refer to Exlibris::Primo::Source::Local::NyuAleph to see which source data elements are available.
    @view_data[:source_data].each { |key, value| 
      instance_variable_set("@#{key}".to_sym,  value)
    } unless @view_data.nil?
    @user_request = @svc_type.request if @svc_type
    @aleph_rest_url = @aleph_url+":1891/rest-dlf" unless @aleph_url.nil?
    @illiad_url = "#{@illiad_url}/illiad/illiad.dll/OpenURL?#{@svc_type.request.to_context_object.kev}"
    @pickup_location = params.fetch(:pickup_location, "")
    @is_scan = (params.fetch(:entire, "yes") == "no") ? true : false
    # Set note_2 as entire_yes/entire_no
    params[:note_2] = (@is_scan) ? "entire_no" : "entire_yes"
  end

  def index
  end 

  def reset
  end

  def send_available
    send_aleph(RequestsHelper.request_available?(@view_data, current_user_session), params)
  end

  def send_ill
    if RequestsHelper.request_ill?(@view_data, current_user_session)
      redirect_to @illiad_url and return
    else
      flash[:error] = RequestsHelper.permission_error
      redirect_to params.merge(:action => "index")        
    end
  end

  def send_in_processing
    send_aleph(RequestsHelper.request_in_processing?(@view_data, current_user_session), params)
  end

  def send_on_order
    send_aleph(RequestsHelper.request_on_order?(@view_data, current_user_session), params)
  end

  def send_offsite
    send_aleph(RequestsHelper.request_offsite?(@view_data, current_user_session), params)
  end

  def send_recall
    send_aleph(RequestsHelper.request_recall?(@view_data, current_user_session), params)
  end

  private
  # TODO: Wrap patron call in begin/rescue
  def send_aleph(request_check=false, params=nil)
    if request_check and patron
      begin
        patron.place_hold(@aleph_item_adm_library, @aleph_doc_library, @aleph_doc_number, @aleph_item_id, params)
        respond_to do |format|
          format.html {  render }
        end
      rescue Exception => e
        if patron.error.nil?
          Rails.logger.error("Unexpected error in request controller.")
          flash[:error] = RequestsHelper.unexpected_error
        else
          flash[:error] = "<div class=\"validation_errors\"><span>#{patron.error}</span></div>"
        end
        redirect_to params_preserve_xhr(params.merge(:action => "index"))        
      end
    elsif !request_check
      flash[:error] = RequestsHelper.permission_error
      redirect_to params_preserve_xhr(params.merge(:action => "index"))        
    else
      Rails.logger.error("Unexpected error in request controller.")
      flash[:error] = RequestsHelper.unexpected_error
      redirect_to params_preserve_xhr(params.merge(:action => "index"))        
    end
  end

  def patron
    @patron ||= Exlibris::Aleph::Patron.new(current_user.user_attributes[:nyuidn], @aleph_rest_url)
  end
end