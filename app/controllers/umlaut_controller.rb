require 'umlaut'
require 'umlaut_configurable'

# Superclass for all Umlaut controllers, to hold default behavior,
# also hold global configuration. It's a superclass rather than a module,
# so we can use Rails 3 hieararchical superclass view lookup too if we want,
# for general umlaut views. And also so local app can over-ride
# methods here once, and have it apply to all Umlaut controllers.
# But there's not much magic in here or anything, the
# common behavior is ordinary methods available to be called, mostly.
#
# This class is copied into the local app -- the default implementation
# does nothing but 'include Umlaut::ControllerBehavior'
#
# You will ordinarily set config here, and can also over-ride
# methods from Umlaut::ControllerBehavior if desired. Or add
# additional helpers to over-ride Umlaut helpers if needed.
class UmlautController < ApplicationController
  before_filter :institutional_config
  include Umlaut::ControllerBehavior

  # Set the config based on the institutional settings.
  def institutional_config
    # Insitution for the closure.
    institution = current_primary_institution
    self.umlaut_config.configure do
      if institution and institution.views and institution.views["sfx_base_url"]
        sfx do
          sfx_base_url institution.views["sfx_base_url"]
        end
      end
    end
  end

  # Is the service response (i.e. holding) requestable 
  def requestable?(service_response)
    request_authorizer(service_response).requestable?
  end
  helper_method :requestable?

  # Return a request authorizer for the given service_response
  def request_authorizer(service_response)
    HoldingRequestAuthorizer.new(Holding.new(service_response), current_user)
  end
  private :request_authorizer

  umlaut_config.configure do
    app_name 'GetIt'

    # URL to image to use for link resolver in some self-links,
    # OR name of image asset in local app.
    link_img_url "http://library.nyu.edu/getit.gif"

    # Sometimes Umlaut sends out email, what email addr should it be from?
    from_email_addr 'no-reply@library.nyu.edu'

    # Local layout for UmlautController's, instead of
    # built in 'umlaut' layout?
    # layout "application"
    resolve_layout "resolve"
    search_layout "bobcat"
    # search_layout "search"

    # A help url used on error page and a few other places.
    help_url  "http://library.nyu.edu/ask"

    # If OpenURL came from manual entry of title/ISSN, and no match is found in
    # link resolver knowledge base, display a warning to the user of potential
    # typo?
    # entry_not_in_kb_warning true

    # rfr_ids used for umlaut generated pages.
    # rfr_ids do
    #   opensearch  "info:sid/umlaut.code4lib.org:opensearch"
    #   citation    "info:sid/umlaut.code4lib.org:citation"
    #   azlist      'info:sid/umlaut.code4lib.org:azlist'
    # end

    # Referent filters. Sort of like SFX source parsers.
    # hash, key is regexp to match a sid, value is filter object
    # (see lib/referent_filters )
    # add_referent_filters!( :match => /.*/, :filter => DissertationCatch.new )

    # Turn off permalink-generation? If you don't want it at all, or
    # don't want it temporarily because you are pointing at a database
    # that won't last.
    # create_permalinks false

    # How many seconds between updates of the background updater for background
    # services?
    # poll_wait_seconds 4

    # Configuration for the 'search' functions -- A-Z lookup
    # and citation entry.
    search do
      # Is your SFX database connection, defined in database.yml under
      # sfx_db and used for A-Z searches, Sfx3 or Sfx4?  Other SearchMethods
      # in addition to SFX direct db may be provided later.
      # az_search_method  SearchMethods::Sfx4
      az_search_method  SearchMethods::Sfx4Solr::Local

      # When talking directly to the SFX A-Z list database, you may
      # need to set this, if you have multiple A-Z profiles configured
      # and don't want to use the 'default.
      # sfx_az_profile "default"

      # can set to "_blank" etc.
      result_link_target _blank
    end

    # config only relevant to SFX use
    sfx do
      # base sfx url to use for search actions, error condition backup,
      # and some other purposes. For search actions (A-Z), direct database
      # connection to your SFX db also needs to be defined in database.yml
      sfx_base_url Settings.institutions.default.views.sfx_base_url

      # Umlaut tries to figure out from the SFX knowledge base
      # which hosts are "SFX controlled", to avoid duplicating SFX
      # urls with urls from catalog. But sometimes it misses some, or
      # alternate hostnames for some. Regexps matching against
      # urls can be included here. Eg,
      # additional_sfx_controlled_urls  [
      #    %r{^http://([^\.]\.)*pubmedcentral\.com}
      #  ]
      # additional_sfx_controlled_urls []
    end

    holdings do
      available_statuses ["Available", "Check Availability", "Offsite Available"]
    end

    # Advanced topic, you can declaratively configure
    # what sections of the resolve page are output where
    # and how using resolve_sections and add_resolve_sections!
    add_resolve_sections! do
      div_id "wayfinder"
      html_area :sidebar
      bg_update false
      partial "wayfinder"
      show_heading false
      show_spinner false
      visibility :responses_exist 
    end

    export_citation = resolve_sections[resolve_sections.index {|s| s[:div_id].to_s == "export_citation"}]
    export_citation[:section_title] = "Send/Share"
    # export_citation[:bg_update] = false
    # export_citation[:visibility] = :complete_with_responses

    document_delivery = resolve_sections[resolve_sections.index {|s| s[:div_id].to_s == "document_delivery"}]
    document_delivery[:section_title] = "Get a copy from Interlibrary Loan (ILL)"
    document_delivery[:section_prompt] = "Please do not use for available or offsite materials."
    document_delivery[:bg_update] = true

    resolve_sections do
      ensure_order!("wayfinder", "service_errors")
      ensure_order!("wayfinder", "highlighted_link")
      ensure_order!("wayfinder", "related_items")
      ensure_order!("wayfinder", "export_citation")
      ensure_order!("wayfinder", "coins")
      ensure_order!("wayfinder", "help")
      ensure_order!("export_citation", "highlighted_link")
      ensure_order!("highlighted_link", "related_items")
    end
  end

  def create_collection
    return Collection.new(@user_request, services(institutions_in_play(params[UserSession.institution_param_key])))
  end
  protected :create_collection

  def institutions_in_play(requested_institution)
    institutions_in_play = []
    # Always add default institutions
    institutions_in_play += Institutions.defaults
    # Remove NYU at the start
    institutions_in_play.reject! { |institution| institution.code == :NYU }
    # Start adding conditional institutions
    # beginning with the requested institution from the URL
    if requested_institution
      requested_institution = 
        Institutions.institutions[requested_institution.to_sym]
      if requested_institution.present?
        institutions_in_play << requested_institution
      end
    end
    # Get all institutions based on IP
    if request.present?
      institutions_in_play += Institutions.with_ip(request.remote_ip)
    end
    # Get all user associated institutions
    institutions_in_play += user_institutions
    # Add NYU if we only have the one default
    if (institutions_in_play.length == 1 and institutions_in_play.first.code == :default)
      institutions_in_play << Institutions.institutions[:NYU]
    end
    # Only get uniq institutions
    institutions_in_play.uniq!
    # Log the institutions
    Rails.logger.info("The following institutions are in play: #{institutions.collect{|i| i.name}.inspect}")
    # Return a copy
    return institutions_in_play.collect{ |i| i }
  end
  private :institutions_in_play

  def user_institutions
    if current_user.present? and current_user.primary_institution.present?
      [current_user.primary_institution] 
    else
      []
    end
  end
  private :user_institutions

  # Add services belonging to institutions
  def services(institutions_in_play)
    services = {}
    institutions_in_play.each do | institution |
      # trim out ones with disabled:true
      services.merge!(institution.services.reject {|id, hash| hash && hash["disabled"] == true})
      # services.merge!(ServiceStore.config["#{institution}"]["services"].reject {|id, hash| hash && hash["disabled"] == true})
    end
    return services
  end
  private :services
end
