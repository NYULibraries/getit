class OpenURLService < Service
  required_config_params :base_url, :display_text

  # Overrides Service#initialize.
  def initialize(config)
    @service_types = [ "highlighted_link" ]
    super(config)
    @base_url = @base_url + "?" if /\?/.match(@base_url).nil?
  end

  # Overrides Service#service_types_generated.
  def service_types_generated
    @service_types.collect { |type|
      ServiceTypeValue[type.to_sym] }
  end

  # Overrides Service#handle.
  def handle(request)
    url = "#{@base_url}#{request.to_context_object.kev}"
    url = url.chop if url.end_with?("%")
    request.add_service_response({
      :service => self,
      :display_text => @display_text,
      :url => url,
      :service_type_value => @service_types.first } )
    return request.dispatched(self, true)
  end
end