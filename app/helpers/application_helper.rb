module ApplicationHelper
  def search_stylesheets
    # search_stylesheets = stylesheet_link_tag "https://library.nyu.edu/css/common/bobcat/#{current_primary_institution.views["dir"]}/bobcat.css" unless current_primary_institution.name.eql?("NYU")
    search_stylesheets = stylesheet_link_tag "search"
  end

  def resolve_stylesheets
    # resolve_stylesheets = stylesheet_link_tag 'https://library.nyu.edu/css/common/getit.css'
    # resolve_stylesheets = stylesheet_link_tag "https://library.nyu.edu/css/common/bobcat/#{current_primary_institution.views["dir"]}/getit.css" unless current_primary_institution.name.eql?("NYU")
    resolve_stylesheets = stylesheet_link_tag "resolve"
  end

  def search_javascripts
    # search_javascripts = javascript_include_tag "https://library.nyu.edu/scripts/jquery/plugins/jquery.nyulibrary.libraryhelp.js"
    # search_javascripts += javascript_include_tag "https://library.nyu.edu/scripts/jquery/plugins/jquery.poshytip.min.js"
    # search_javascripts += javascript_include_tag "https://library.nyu.edu/scripts/jquery/plugins/jquery.nyulibrary.popuptip.js"
    search_javascripts = javascript_include_tag "search"
  end

  def resolve_javascripts
    resolve_javascripts = javascript_include_tag "resolve"
  end
  
  def institutional_partial(partial)
    render :partial=> "#{current_primary_institution.views["dir"]}/#{partial}" if 
      lookup_context.exists?("#{current_primary_institution.views["dir"]}/#{partial}", [], true)
  end

  def crumbs
    crumbs = []
    unless params["controller"] == "export_email"
      institutional_breadcrumbs = current_primary_institution.views["breadcrumbs"]
      crumbs << link_to(institutional_breadcrumbs["title"], institutional_breadcrumbs["url"])
      crumbs << link_to('BobCat', 'http://bobcat.library.nyu.edu/nyu')
      if params["action"].eql?("journal_list") or params["action"].eql?("journal_search")
        crumbs << link_to('E-Journals', :controller=>'search')
        crumbs << "Results"
      else
        crumbs << "E-Journals A-Z"
      end
    end
  end

  def permalink_nav
    content_tag(:div, :id => "permalink") {content_tag(:span, "URL: ")+ link_to(current_permalink_url, current_permalink_url)}if permalink = current_permalink_url()
  end

  def link_to_with_popover(*args)
    klass = args.delete_at 3
    content = args.delete_at 2
    args[2] = {"title" => args[0], "data-content" => "<div class=\"#{klass}\">#{content}</div>", :rel => "popover", :class => "#{klass}"}
    link_to(*args)
  end

  def link_to_remote_popover(*args)
    popover_options = args.delete_at 3||{}
    link_class = args.delete_at 2
    popover_options["data-class"] = link_class if popover_options["data-class"].nil?
    args[2] = {"title" => args[0], :rel => "popover", :class => link_class, :target => "_blank"}.merge(popover_options)
    link_to(*args)
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