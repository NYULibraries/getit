class OpenURLService < Service
  required_config_params :base_url, :display_text

  def initialize(config)
    @service_types = [ "highlighted_link" ]
    super(config)
    @base_url = @base_url + "?" if /\?/.match(@base_url).nil?
  end
  
  # Overwrites Service#service_types_generated.
  def service_types_generated
    types = Array.new
    @service_types.each do |type|
      types.push(ServiceTypeValue[type.to_sym])
    end
    return types
  end
  
  def handle(request)
    service_data = {}
    service_data[:url] = "#{@base_url}#{request.to_context_object.kev}"
    service_data[:display_text] = @display_text
    request.add_service_response(
      { :service => self,
        :display_text => service_data[:display_text],
        :url => service_data[:url],
        :service_data => service_data,
        :service_type_value => @service_types.first } )
    return request.dispatched(self, true)
  end
end