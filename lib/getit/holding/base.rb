module GetIt
  module Holding
    class Base
      attr_reader :service_response, :location, :call_number,
        :status, :reliability, :edition, :notes, :coverage

      def initialize(service_response)
        unless service_response.is_a?(ServiceResponse)
          raise ArgumentError.new("Expecting #{service_response} to be a ServiceResponse")
        end
        unless service_response.service_type_value_name == 'holding'
          raise ArgumentError.new("Expecting #{service_response} to be a \"holding\" ServiceResponse")
        end
        @service_response = service_response
        @location = view_data[:collection_str]
        @call_number = view_data[:call_number]
        @status = view_data[:status]
        @reliability = view_data[:match_reliability]
        @edition = view_data[:edition_str]
        @notes = view_data[:notes]
        @coverage = view_data[:coverage]
      end

      def expired?
        view_data[:expired] == true
      end

      def expire!
        service_response.take_key_values(expired: true)
        service_response.save!
      end

      protected
      extend Forwardable
      # Delegate view_data and destroy! method to the service_response
      def_delegators :service_response, :view_data, :destroy!
    end
  end
end
