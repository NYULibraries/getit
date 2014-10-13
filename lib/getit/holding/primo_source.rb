module GetIt
  module Holding
    class PrimoSource < GetIt::Holding::Base
      def initialize(service_response)
        super(service_response)
        if service_response.service_id != 'NYU_Primo_Source'
          raise ArgumentError.new("Expecting #{service_response} to have service_id 'NYU_Primo_Source'")
        end
      end

      def bobst_reserve?
        source_data[:sub_library_code] == 'BRES'
      end

      protected
      # Source data from Exlibris::Primo::Holding
      def source_data
        @source_data ||= view_data[:source_data]
      end
    end
  end
end
