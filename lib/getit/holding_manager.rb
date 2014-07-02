module GetIt
  class HoldingManager
    attr_reader :service_response, :holding

    def initialize(service_response)
      unless service_response.is_a?(ServiceResponse)
        raise ArgumentError.new("Expecting #{service_response} to be a ServiceResponse")
      end
      @service_response ||= service_response
      @holding = begin
        if service_response.service_id == 'NYU_Primo'
          Holding::Primo.new(service_response)
        else
          Holding::NyuAleph.new(service_response)
        end
      end
    end
  end
end
