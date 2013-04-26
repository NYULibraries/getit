# app/views/layouts/bobcat.rb
module Views
  module Layouts
    class Bobcat < ActionView::Mustache
      def javascripts
        javascript_include_tag "search"
      end

      def application
        "GetIt @ NYU Libraries"
      end

      # Using Gauges?
      def gauges?
        (Rails.env.eql?("production") and (not gauges_tracking_code.nil?))
      end

      def gauges_tracking_code
        '5114fb95f5a1f555df00002b'
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