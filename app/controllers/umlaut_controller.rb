require 'umlaut'

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
    logged_in_user = current_user
    logged_in_user_institution = institution_from_current_user
    ezborrow_authorizer = EZBorrowAuthorizer.new(logged_in_user) unless current_user.nil?
    self.umlaut_config.configure do
      if institution and institution.views and institution.views["sfx_base_url"]
        sfx do
          sfx_base_url institution.views["sfx_base_url"]
        end
      end
      # Configure EZBorrow/BorrowDirect
      borrow_direct do
        # Reset BorrowDirect/EZBorrow defaults based on current institution
        if logged_in_user_institution.try(:services).try(:[], "EZBorrow")
          BorrowDirect::Defaults.api_key = logged_in_user_institution.services["EZBorrow"]["api_key"]
          if logged_in_user_institution.try(:services).try(:[], "EZBorrow").try(:[], "api_base")
            BorrowDirect::Defaults.api_base = logged_in_user_institution.services["EZBorrow"]["api_base"]
          end
          # Should we only rely on a local availability check, or check Ezborrow too?
          # https://github.com/team-umlaut/umlaut_borrow_direct#local-availability-check
          local_availability_check proc {|request, service|
            # Display the EZBorrow check availability if:
            # => 1. There are not any holdings that match an available status at the current institution library
            # => 2. The user is logged in
            # => 3. The logged in use is authorized to use ezborrow for their institution
            available_at_library = request.get_service_type(:holding).find do |sr|
              UmlautController.umlaut_config.holdings.available_statuses.include?((sr.view_data[:status].is_a?(Exlibris::Nyu::Aleph::Status)) ? sr.view_data[:status].value : sr.view_data[:status]) &&
              logged_in_user_institution.services["EZBorrow"]["check_library_codes"].include?(sr.service_data[:library].code) &&
              sr.view_data[:match_reliability] != ServiceResponse::MatchUnsure
            end
            !(logged_in_user.present? && ezborrow_authorizer.authorized?) || available_at_library.present?
          }
        else
          local_availability_check proc {|request, service|
            true
          }
        end
      end
    end
  end

  # Is the service response requestable
  def requestable?(holding)
    # Only NyuAleph holdings are requestable
    return false unless holding.is_a? GetIt::Holding::NyuAleph
    if current_user.present?
      holding_request_authorizer(holding_request(holding)).requestable?
    else
      holding.requestable?
    end
  end
  helper_method :requestable?

  def holding_request_authorizer(holding_request)
    HoldingRequest::Authorizer.new(holding_request)
  end
  private :holding_request_authorizer

  def holding_request(holding)
    HoldingRequest.new(holding, current_user)
  end
  private :holding_request

  umlaut_config.configure do
    app_name 'GetIt'

    # URL to image to use for link resolver in some self-links,
    # OR name of image asset in local app.
    link_img_url "https://s3.amazonaws.com/nyulibraries-www-assets/web-images/getit.gif"

    # Sometimes Umlaut sends out email, what email addr should it be from?
    from_email_addr 'lib-no-reply@nyu.edu'

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
    poll_wait_seconds 2

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
      sfx_base_url 'http://sfx.library.nyu.edu/sfxlcl41?'

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

    # Removing bib_tool from sidebar
    # add_resolve_sections! do
    #   div_id "bib_tool"
    #   html_area :sidebar
    #   bg_update false
    #   show_spinner false
    #   visibility :responses_exist
    # end

    export_citation = resolve_sections[resolve_sections.index {|s| s[:div_id].to_s == "export_citation"}]
    export_citation[:section_title] = "Send/Share"
    # export_citation[:bg_update] = false
    # export_citation[:visibility] = :complete_with_responses

    help = resolve_sections[resolve_sections.index {|s| s[:div_id].to_s == "help"}]
    help[:section_title] = "Questions"

    document_delivery = resolve_sections[resolve_sections.index {|s| s[:div_id].to_s == "document_delivery"}]
    document_delivery[:section_title] = "Get a copy from Interlibrary Loan (ILL)"
    document_delivery[:section_prompt] = "Please do not use for available or offsite materials."
    document_delivery[:bg_update] = true

    # Original order is:
    #   cover_image, fulltext, search_inside, excerpts, audio,
    #     holding, document_delivery, table_of_contents, abstract
    # Desired order is:
    #   cover_image, search_inside, fulltext, holding, document_delivery,
    #     audio, excerpts, table_of_contents, abstract

    # Get each resolve section from whereever they are
    search_inside = resolve_sections.remove_section("search_inside")
    holding = resolve_sections.remove_section("holding")
    document_delivery = resolve_sections.remove_section("document_delivery")
    audio = resolve_sections.remove_section("audio")
    excerpts = resolve_sections.remove_section("excerpts")
    table_of_contents = resolve_sections.remove_section("table_of_contents")
    abstract = resolve_sections.remove_section("abstract")
    borrow_direct = UmlautBorrowDirect.resolve_section_definition

    # And insert them in the desired order
    resolve_sections.insert_section(search_inside, :before => "fulltext")
    resolve_sections.insert_section(holding, :after => "fulltext")
    resolve_sections.insert_section(borrow_direct, :after => "holding")
    resolve_sections.insert_section(document_delivery, :after => "borrow_direct")
    resolve_sections.insert_section(audio, :after => "document_delivery")
    resolve_sections.insert_section(excerpts, :after => "audio")
    resolve_sections.insert_section(table_of_contents, :after => "excerpts")
    resolve_sections.insert_section(abstract, :after => "table_of_contents")

    # Reorder sidebar sections as well
    wayfinder = resolve_sections.remove_section("wayfinder")
    resolve_sections.insert_section(wayfinder, before: "questions")

    # Supplies logic for when to highlight borrow_direct section
    # add_section_highlights_filter! UmlautBorrowDirect.section_highlights_filter

  end

  def create_collection
    return Collection.new(@user_request, services(institutions_in_play(params['umlaut.institution'])))
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
    Rails.logger.info("The following institutions are in play: #{institutions_in_play.collect{|i| i.name}.inspect}")
    # Return a copy
    return institutions_in_play.collect{ |i| i }
  end
  private :institutions_in_play

  def user_institutions
    if current_user.present? && current_user.institution.present?
      [current_user.institution]
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
