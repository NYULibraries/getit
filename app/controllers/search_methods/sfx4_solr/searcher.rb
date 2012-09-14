module SearchMethods
  module Sfx4Solr
    module Searcher
      def self.included(klass)
        klass.class_eval do
          extend SearchMethods::Sfx4::UrlFetcher
          include InstanceMethods
        end
      end
      
      module InstanceMethods
        protected
        def find_by_title
          find_by_title(title_query_param)
        end
      
        def find_by_group
          find_by_title(letter_group_param)
        end
      
        private
        def find_by_title(query_param)
          query = az_title_klass.connection.quote_string(query_param)
          titles = case search_type_param
            when "contains"
              az_title_klass.search {fulltext query}.results
            when "begins"
              az_title_klass.search {with(:title_exact).starts_with(query)}.results
            else # exact
              az_title_klass.search {with(:title_exact, query)}.results
            end   
          return [titles.count, titles.map{|title| title.to_context_object}]
        end

        def find_by_group(query_param)
          query = az_title_klass.connection.quote_string(query_param)
          titles = az_title_klass.search {with(:letter_group, query)}.results
          return [titles.count, titles.map{|title| title.to_context_object}]
        end
    
        def letter_group_param
          case params[:id]
          when /^Other/i
            "Others"
          else
            "#{params[:id].upcase}"
          end
        end
      end
    end
  end
end