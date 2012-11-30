# app/views/layouts/bobcat.rb
module Views
  module Layouts
    class Bobcat < ActionView::Mustache
      def stylesheets
        search_stylesheets
      end

      def javascripts
        search_javascripts
      end

      def application
        "GetIt @ NYU Libraries"
      end

      def breadcrumbs
        breadcrumbs = super
        unless params["controller"] == "export_email"
          if params["action"].eql?("journal_list") or params["action"].eql?("journal_search")
            breadcrumbs << link_to('E-Journals', :controller=>'search')
            breadcrumbs << "Results"
          else
            breadcrumbs << "E-Journals A-Z"
          end
        end
      end
    end
  end
end