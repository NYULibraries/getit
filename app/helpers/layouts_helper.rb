# app/views/layouts/bobcat.rb
module LayoutsHelper
  def application_javascript
    javascript_include_tag "search"
  end

  def gauges?
    Rails.env.production?
  end

  def gauges_tracking_code
    views["gauges_tracking_code"]
  end

  def google_analytics?
    gauges?
  end

  def google_analytics_tracking_code
    ENV['GOOGLE_ANALYTICS_TRACKING_CODE']
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
