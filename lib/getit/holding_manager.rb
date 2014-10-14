module GetIt
  class HoldingManager
    VALID_SERVICE_IDS = ['NYU_Primo', 'NYU_Primo_Source']

    attr_reader :service_response, :holding

    def initialize(service_response)
      unless service_response.is_a?(ServiceResponse)
        raise ArgumentError.new("Expecting #{service_response} to be a ServiceResponse")
      end
      unless VALID_SERVICE_IDS.include? service_response.service_id
        raise ArgumentError.new("Expecting #{service_response} to have a valid service id")
      end
      @service_response ||= service_response
      @holding = begin
        if service_response.service_id == 'NYU_Primo'
          Holding::Primo.new(service_response)
        elsif service_response.service_id == 'NYU_Primo_Source'
          if Holding::NyuAleph::VALID_SOURCES.include? service_response.view_data[:source_id]
            Holding::NyuAleph.new(service_response)
          else
            Holding::PrimoSource.new(service_response)
          end
        end
      end
    end
  end
end
