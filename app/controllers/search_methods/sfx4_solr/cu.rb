module SearchMethods
  module Sfx4Solr
    module Cu
      include SearchMethods::Sfx4Solr::Searcher

      # Class method for the module that gets called by the umlaut:load_sfx_urls task.
      # Determines whether we should attempt to fetch SFX urls.
      # Will probably be deprecated in the near future.
      def self.fetch_urls?
        sfx4_base.connection_configured?
      end

      # Class method for the module that gets called by the umlaut:load_sfx_urls task.
      # Kind of hacky way of trying to extract target URLs from SFX4.
      # Will probably be deprecated in the near future.
      def self.fetch_urls
        sfx4_base.fetch_urls
      end

      # Class method for the module.
      # Returns the SFX4 base class in order to establish a connection.
      def self.sfx4_base
        # Need to do this convoluted Module.const_get so that we find the
        # correct class. Otherwise the module looks locally and can't find it.
        Module.const_get(:Sfx4).const_get(:Cu).const_get(:Base)
      end

      def az_title_klass
        Module.const_get(:Sfx4).const_get(:Cu).const_get(:AzTitle)
      end
      protected :az_title_klass
    end
  end
end
