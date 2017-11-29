class Wayfinder < Service
  required_config_params :known_rfrs

  # Overrides Service#initialize.
  def initialize(config)
    @service_types = [ "wayfinder" ]
    super(config)
  end

  # Overwrites Service#service_types_generated.
  def service_types_generated
    @service_types.collect { |type|
      ServiceTypeValue[type.to_sym] }
  end

  # Overrides Service#handle.
  def handle(request)
    if(request.get_service_type("wayfinder", { :refresh => true }).empty?)
      rfr_id = request.referrer_id
      unless(rfr_id.nil?)
        @known_rfrs.each do |known_rfr|
          match = known_rfr["regex"].match(rfr_id)
          next if match.nil?
          url = "#{known_rfr["base_url"]}"
          url += match[1] unless match[1].nil? || known_rfr["return_to_base_url"]
          known_rfr["querystring_metadata"].each { |key, value|
            url += "&#{key}=#{request.referent.metadata[value]}"
          } unless known_rfr["querystring_metadata"].nil?
          request.add_service_response({
            :service => self,
            :rfr_name => known_rfr["name"],
            :display_text => known_rfr["display_text"],
            :url => url,
            :service_type_value => @service_types.first})
          break
        end
      end
    end
    return request.dispatched(self, true)
  end
end
