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
          _find_by_title(title_query_param, search_type_param, context_object_from_params, params[:page])
        end
        
        def autocomplete_title
          _autocomplete_title(title_query_param, search_type_param, params[:page])
        end
      
        def find_by_group
          _find_by_group(_letter_group_param, context_object_from_params, params[:page])
        end

        private
        def _search_by_title(query, search_type, page=1)
          search = case search_type
            when "contains"
              az_title_klass.search {
                keywords query, :fields => [:title]
                with(:az_profile, "default")
                order_by(:title_sort, :asc)
                paginate(:page => page, :per_page => 20)
              }
            when "begins"
              az_title_klass.search {
                with(:az_profile, "default")
                with(:title_exact).starting_with(query)
                order_by(:title_sort, :asc)
                paginate(:page => page, :per_page => 20)
              }
            else # exact
              az_title_klass.search {
                with(:az_profile, "default")
                with(:title_exact, query)
                order_by(:title_sort, :asc)
                paginate(:page => page, :per_page => 20)
              }
            end
        end
        
        def _autocomplete_title(query, search_type, page=1)
          search = _search_by_title(query, search_type, page)
          search.hits.map{|hit| hit.stored(:title_display)}
        end

        def _find_by_title(query, search_type, context_object, page=1)
          search = _search_by_title(query, search_type, page)
          return [search.results.map{|title| title.to_context_object context_object}, search.total]
        end

        def _find_by_group(query, context_object, page=1)
          search = az_title_klass.search {
            with(:letter_group, query)
            order_by(:title_sort, :asc)
            paginate(:page => page, :per_page => 20)
          }
          return [search.results.map{|title| title.to_context_object context_object}, search.total]
        end
    
        def _letter_group_param
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