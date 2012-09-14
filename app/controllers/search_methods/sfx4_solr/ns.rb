module SearchMethods
  module Sfx4Solr
    module Ns
      def self.az_title_klass
        Module.const_get(:Sfx4).const_get(:Ns).const_get(:AzTitle)
      end
      def az_title_klass
        self.az_title_klass
      end
      # include SearchMethods::Sfx4Solr::Searcher
    end
  end
end