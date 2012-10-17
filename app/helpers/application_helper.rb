module ApplicationHelper
  def search_stylesheets
    # search_stylesheets += stylesheet_link_tag 'https://library.nyu.edu/css/common/bobcat.css'
    search_stylesheets = stylesheet_link_tag "http://fonts.googleapis.com/css?family=Muli"
    search_stylesheets += stylesheet_link_tag "https://library.nyu.edu/css/common/bobcat/#{current_primary_institution.views["dir"]}/bobcat.css" unless current_primary_institution.name.eql?("NYU")
    search_stylesheets += stylesheet_link_tag "http://library.nyu.edu/scripts/jquery/css/nyulibraries_gray/jquery-ui.css"
    search_stylesheets += stylesheet_link_tag "search"
  end

  def resolve_stylesheets
    resolve_stylesheets = stylesheet_link_tag 'https://library.nyu.edu/css/common/getit.css'
    resolve_stylesheets += stylesheet_link_tag "https://library.nyu.edu/css/common/bobcat/#{current_primary_institution.views["dir"]}/getit.css" unless current_primary_institution.name.eql?("NYU")
    resolve_stylesheets += stylesheet_link_tag "http://fonts.googleapis.com/css?family=Muli"
    resolve_stylesheets += stylesheet_link_tag "resolve"
  end

  def search_javascripts
    search_javascripts = javascript_include_tag "https://library.nyu.edu/scripts/jquery/plugins/jquery.nyulibrary.libraryhelp.js"
    search_javascripts += javascript_include_tag "https://library.nyu.edu/scripts/jquery/plugins/jquery.poshytip.min.js"
    search_javascripts += javascript_include_tag "https://library.nyu.edu/scripts/jquery/plugins/jquery.nyulibrary.popuptip.js"
    search_javascripts += javascript_include_tag "search"
  end

  def resolve_javascripts
    resolve_javascripts = javascript_include_tag "resolve"
  end

  def breadcrumbs
    unless params["controller"] == "export_email"
      institutional_breadcrumbs = current_primary_institution.views["breadcrumbs"]
      breadcrumbs = 
        content_tag :li, link_to(institutional_breadcrumbs["title"], institutional_breadcrumbs["url"]).concat(content_tag(:span, ">", :class => "divider"))
      breadcrumbs += 
        content_tag :li, link_to('BobCat', 'http://bobcat.library.nyu.edu/nyu').concat(content_tag(:span, ">", :class => "divider"))
      if params["action"].eql?("journal_list") or params["action"].eql?("journal_search")
        breadcrumbs += 
          content_tag :li, link_to('E-Jounals', :controller=>'search').concat(content_tag(:span, ">", :class => "divider"))
        breadcrumbs += content_tag :li, "Results"
      else
        breadcrumbs += content_tag :li, "E-Journals A-Z"
      end
      content_tag :ul, breadcrumbs, :class => ["pull-left"] unless breadcrumbs.nil?
    end
  end

  def login
    login = content_tag :li, ((current_user) ? 
      content_tag(:i, nil, :class => "icons-famfamfam-lock") + link_to("Log-out #{current_user.firstname}", logout_url, :class=>"logout") : 
        content_tag(:i, nil, :class => "icons-famfamfam-lock_open") + link_to("Login", login_url({"umlaut.institution" => current_primary_institution.name}), :class=>"login"))
    content_tag :ul, login, :class => ["unstyled"]
  end

  def tabs(classes="")
    institutional_tabs = current_primary_institution.views["tabs"]
    content_tag(:ul, 
      institutional_tabs.collect{|id, values|
        content_tag(:li, 
          ((id.eql? "journals") ? 
            link_to(values["display"], {:controller => "search"}, :title => values["tip"], :class => ["tip-delayed"]) : 
              link_to(values["display"], values["url"], {:title => values["tip"], :class => "tip-delayed"})),
          :id =>id, :class => (id.eql? "journals") ? "active" : "")}.join.html_safe, 
      :class => classes)
  end

  def permalink_nav
    content_tag(:div, "URL: #{link_to current_permalink_url, current_permalink_url}", :id => "permalink") if permalink = current_permalink_url()
  end

  def expire_old_holdings(request, holdings)
    # Delete NYU_Primo_Source responses in order to force a refresh
    # Only do this after all services have finished.
    if request.services_in_progress.empty?
      dispatched_services = request.dispatched_services.find(:all, :conditions => ['service_id = "NYU_Primo_Source"'])
        dispatched_services.each do |dispatched_service|
        # Destroy dispatched service 
        # to force the service to run again.
        dispatched_service.destroy unless dispatched_service.status != DispatchedService::Successful
      end # destroy dispatched services block
      holdings.each do |holding|
        next unless (holding.service_id == "NYU_Primo_Source")
        expired = holding.view_data[:expired] and latest = holding.view_data[:latest]
        next unless not expired or latest
        # :latest determines whether we show the holding in other services, e.g. txt and email.
        # It persists for one more cycle than :expired so services that run after
        # this one, but in the same resolution request have access to the latest holding data.
        holding.take_key_values(:latest => false) unless not expired
        # :expired determines whether we show the holding in this service
        # Since we are done with this holding, the data has expired.
        holding.take_key_values(:expired => true) unless expired
        holding.save!
      end # each holding block
    end # all services finished?
  end
end