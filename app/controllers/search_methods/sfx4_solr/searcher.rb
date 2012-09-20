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
          _find_by_title(title_query_param, search_type_param, context_object_from_params, param[:page])
        end
      
        def find_by_group
          _find_by_group(__letter_group_param)
        end

        private
        def _find_by_title(query_param, search_type, context_object, page=1)
          Rails.logger.warn az_title_klass.to_s
          query = az_title_klass.connection.quote_string(query_param)
          titles = case search_type
            when "contains"
              az_title_klass.search {
                fulltext query
                order_by(:title_sort, :asc)
                paginate(:page => page, :per_page => 20)
              }.results
            when "begins"
              az_title_klass.search {
                with(:title_exact).starts_with(query)
                order_by(:title_sort, :asc)
                paginate(:page => page, :per_page => 20)
              }.results
            else # exact
              az_title_klass.search {
                with(:title_exact, query)
                order_by(:title_sort, :asc)
                paginate(:page => page, :per_page => 20)
              }.results
            end   
          return [titles.map{|title| title.to_context_object context_object}, titles.count]
        end

        def _find_by_group(query_param)
          query = az_title_klass.connection.quote_string(query_param)
          titles = az_title_klass.search {with(:letter_group, query)}.results
          return [titles.map{|title| title.to_context_object context_object}, titles.count]
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