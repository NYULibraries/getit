module GetIt
  module Holding
    class Primo < GetIt::Holding::Base
      def initialize(service_response)
        super(service_response)
        if service_response.service_id != 'NYU_Primo'
          raise ArgumentError.new("Expecting #{service_response} to have service_id 'NYU_Primo'")
        end
      end
    end
  end
end
