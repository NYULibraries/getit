# app/views/layouts/bobcat.rb
module Views
  module Layouts
    class Bobcat < ActionView::Mustache
      def application_javascript
        javascript_include_tag "search"
      end

      def gauges_tracking_code
        views["gauges_tracking_code"]
      end

      def breadcrumbs
        breadcrumbs = super
        unless params["controller"] == "export_email"
          if params["action"].eql?("journal_list") or params["action"].eql?("journal_search")
            breadcrumbs << link_to('E-Journals', :controller=>'search')
            breadcrumbs << "Results"
          else
            breadcrumbs << "Journals"
          end
        end
      end
    end
  end
end