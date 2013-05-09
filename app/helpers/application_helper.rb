module ApplicationHelper
  def resolve_stylesheets
    stylesheet_link_tag (current_primary_institution.views["resolve_css"] || "resolve")
  end

  def resolve_javascripts
    javascript_include_tag "resolve"
  end
  
  def institutional_partial(partial)
    render :partial=> "#{current_primary_institution.views["dir"]}/#{partial}" if 
      lookup_context.exists?("#{current_primary_institution.views["dir"]}/#{partial}", [], true)
  end

  def permalink_nav
    content_tag(:div, :id => "permalink") { content_tag(:span, "URL: ") + 
      link_to(current_permalink_url, current_permalink_url) } if current_permalink_url()
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
    service_id = "NYU_Primo_Source"
    unless service_type_in_progress?("holding")
      dispatched_services = 
        request.dispatched_services.find(:all, :conditions => {:service_id => service_id})
      dispatched_services.each do |dispatched_service|
        # Destroy dispatched service 
        # to force the service to run again.
        dispatched_service.destroy unless dispatched_service.status != DispatchedService::Successful
      end # destroy dispatched services block
      holdings.each do |holding|
        next unless (holding.service_id == service_id)
        expired = holding.view_data[:expired]
        latest = holding.view_data[:latest]
        next unless not expired or latest
        # :latest determines whether we show the holding in other services, e.g. txt and email.
        # It persists for one more cycle than :expired so services that run after
        # this one, but in the same resolution request have access to the latest holding data.
        holding.take_key_values(:latest => false) if expired
        # :expired determines whether we show the holding in this service
        # Since we are done with this holding, the data has expired.
        holding.take_key_values(:expired => true) unless expired
        holding.save!
      end # each holding block
    end # all services finished?
  end
end