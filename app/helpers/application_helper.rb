module ApplicationHelper

  def resolve_stylesheets
    stylesheet_link_tag (current_primary_institution.views["resolve_css"] || "resolve")
  end

  def resolve_javascripts
    javascript_include_tag "resolve"
  end

  def institutional_partial(partial)
    if lookup_context.exists?("#{current_primary_institution.views["dir"]}/#{partial}", [], true)
      render partial: "#{current_primary_institution.views["dir"]}/#{partial}"
    end
  end

  def link_to_remote_popover(*args)
    popover_options = args.delete_at 3||{}
    link_class = args.delete_at 2
    popover_options["data-class"] = link_class if popover_options["data-class"].nil?
    args[2] = {"title" => args[0], :rel => "popover", :class => link_class, :target => "_blank"}.merge(popover_options)
    link_to(*args)
  end

  # Delete NYU_Primo_Source responses in order to force a refresh
  def destroy_successful_nyu_primo_source_dispatched_services(request)
    # Only do this after all services have finished.
    unless request.any_services_in_progress?
      nyu_primo_source_dispatched_services =
        request.dispatched_services.where(service_id: 'NYU_Primo_Source')
      nyu_primo_source_dispatched_services.each do |dispatched_service|
        # Destroy dispatched service to force the service to run again.
        unless dispatched_service.status != DispatchedService::Successful
          dispatched_service.destroy
        end
      end
    end
  end

  def expire_or_destroy_nyu_primo_source_service_responses(request)
    # Only do this after all services have finished.
    unless request.any_services_in_progress?
      nyu_primo_source_service_responses =
        request.service_responses.where(service_id: 'NYU_Primo_Source')
      nyu_primo_source_service_responses.each do |service_response|
        holding = GetIt::HoldingManager.new(service_response).holding
        if holding.expired?
          service_response.destroy
        else
          holding.expire!
        end
      end
    end
  end
end
