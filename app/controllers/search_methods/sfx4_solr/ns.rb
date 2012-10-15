module SearchMethods
  module Sfx4Solr
    module Ns
      def az_title_klass
        Module.const_get(:Sfx4).const_get(:Ns).const_get(:AzTitle)
      end
      include SearchMethods::Sfx4Solr::Searcher
    end
  end
end