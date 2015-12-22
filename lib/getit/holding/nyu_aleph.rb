module GetIt
  module Holding
    class NyuAleph < GetIt::Holding::PrimoSource
      VALID_SOURCES = ['nyu_aleph', 'COURSES']
      ILL_STATUSES = ['Request ILL', 'On Order']

      attr_reader :record_id, :item_id, :institution

      def initialize(service_response)
        super(service_response)
        unless VALID_SOURCES.include? view_data[:source_id]
          raise ArgumentError.new("Expecting #{view_data} to have a valid :source_id")
        end
        if source_data.nil?
          raise ArgumentError.new("Expecting #{service_response} to have :source_data")
        end
        @location ||= "#{sub_library} #{collection}"
        @record_id ||= view_data[:ils_api_id]
        @item_id ||= source_data[:item_id]
        @institution ||= view_data[:institution_code]
      end

      def requestable?
        (['yes', 'deferred'].include?(requestability) && from_aleph?) || scannable?
      end

      def ill?
        from_aleph? && (status.checked_out? || status.requested? ||
          status.processing? || status.billed_as_lost? ||
          ILL_STATUSES.include?(status.value))
      end

      def on_order?
        from_aleph? && status.value == 'On Order'
      end

      def available?
        from_aleph? && status.available?
      end

      def scannable?
        from_aleph? && ['NISAW'].include?(sub_library.code)
      end

      def offsite?
        from_aleph? && status.offsite?
      end

      def requested?
        from_aleph? && status.requested?
      end

      def checked_out?
        from_aleph? && status.checked_out?
      end

      def processing?
        from_aleph? && status.processing?
      end

      def reshelving?
        from_aleph? && status.reshelving?
      end

      def bobst_reserve?
        from_aleph? && sub_library.code == 'BRES'
      end

      def recall_period
        @recall_period ||= (sub_library.code == 'BAFC') ? "1 week" : "2 weeks"
      end

      def afc_schedulable?
        from_aleph? && sub_library.code == 'BAFC' && collection.display == 'Main Collection'
      end

      def sub_library
        @sub_library ||= view_data[:library]
      end

      def collection
        @collection ||= view_data[:collection]
      end

      def from_aleph?
        view_data[:from_aleph].present?
      end

      private
      def requestability
        @requestability ||= view_data[:requestability]
      end
    end
  end
end
