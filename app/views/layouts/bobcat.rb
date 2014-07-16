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

      # Login link and icon
      def login(params={})
        (current_user) ? link_to_logout(params) : link_to_login(params)
      end

      # Link to logout
      def link_to_logout(params={})
        icon_tag(:logout) +
          link_to("Log-out #{current_user.firstname}", 
            logout_url(params), class: "logout")
      end
    end
  end
end
