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
      
        def find_by_group
          _find_by_group(_letter_group_param, context_object_from_params, params[:page])
        end

        private
        def _find_by_title(query_param, search_type, context_object, page=1)
          query = az_title_klass.connection.quote_string(query_param)
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
          return [search.results.map{|title| title.to_context_object context_object}, search.total]
        end

        def _find_by_group(query_param, context_object, page=1)
          query = az_title_klass.connection.quote_string(query_param)
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