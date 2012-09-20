module SearchMethods
  module Sfx4Solr
    module Nyu
      def az_title_klass
        Module.const_get(:Sfx4).const_get(:Nyu).const_get(:AzTitle)
      end
      include SearchMethods::Sfx4Solr::Searcher
    end
  end
end