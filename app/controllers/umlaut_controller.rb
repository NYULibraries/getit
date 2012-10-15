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
  # TODO: store in cache so we don't process each time.
  def institutional_config
    # Insitution for the closure.
    institution = current_primary_institution
    self.umlaut_config.configure do
      unless institution.nil? or institution.views.nil?
        sfx do
          sfx_base_url institution.views["sfx_base_url"] unless institution.views["sfx_base_url"].nil?
        end
      end
      unless institution.nil? or institution.controllers.nil?
        search do
          az_search_method institution.controllers["searcher"] unless institution.controllers["searcher"].nil?
        end
      end
    end
  end

  umlaut_config.configure do 
    app_name 'Get It'
  
    # URL to image to use for link resolver in some self-links, 
    # OR name of image asset in local app. 
    link_img_url "http://library.nyu.edu/getit.gif"
  
    # Sometimes Umlaut sends out email, what email addr should it be from?
    from_email_addr 'no-reply@library.nyu.edu'
  
    # Local layout for UmlautController's, instead of
    # built in 'umlaut' layout?
    # layout "application"
    resolve_layout "resolve"
    search_layout "search"
  
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

    # How many seconds between updates of the background updater for background
    # services?
    # poll_wait_seconds 4
  
    # Configuration for the 'search' functions -- A-Z lookup
    # and citation entry. 
    search do
      # Is your SFX database connection, defined in database.yml under
      # sfx_db and used for A-Z searches, Sfx3 or Sfx4?  Other SearchMethods
      # in addition to SFX direct db may be provided later. 
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
      sfx_base_url  'http://sfx.library.nyu.edu/sfxlcl41?'

      # Umlaut tries to figure out from the SFX knowledge base
      # which hosts are "SFX controlled", to avoid duplicating SFX
      # urls with urls from catalog. But sometimes it misses some, or
      # alternate hostnames for some. Regexps matching against
      # urls can be included here. Eg,
      # AppConfig::Base.additional_sfx_controlled_urls = [
      #    %r{^http://([^\.]\.)*pubmedcentral\.com}
      #  ]    
      # additional_sfx_controlled_urls = []
    end

    holdings do
      available_statuses ["Available", "Check Availability", "Offsite Available"]
    end

    # Advanced topic, you can declaratively configure
    # what sections of the resolve page are output where
    # and how using resolve_sections and add_resolve_sections!            
  end

  protected
  def create_collection    
    return Collection.new(@user_request, services(institutions(params[UserSession.institution_param_key])))
  end

  private
  def institutions(requested_institution)
    institutions = []
    # Always add default institutions
    institutions += InstitutionList.instance.defaults
    # Start adding conditional institutions
    if requested_institution
      requested_institution = InstitutionList.instance.get(requested_institution)
      institutions << requested_institution unless requested_institution.nil?
    end
    # Get all institutions based on IP
    institutions += InstitutionList.instance.institutions_with_ip(request.remote_ip) unless request.nil?
    # Get all user associated institutions
    institutions += user_institutions
    institutions.uniq!
    Rails.logger.info("The following insitutions are in play: #{institutions.collect{|i| i.name}.inspect}")
    return institutions.collect{|i| i.name}
  end

  def user_institutions
    user_session = UserSession.find
    user = user_session.record unless user_session.nil?
    return [user.primary_institution] unless user.nil? or user.primary_institution.nil?
    return []
  end

  # Add services belonging to institutions
  def services(institutions)
    services = {}
    institutions.each do | institution |
      # trim out ones with disabled:true
      services.merge!(ServiceStore.config["#{institution}"]["services"].reject {|id, hash| hash && hash["disabled"] == true})
    end
    return services
  end
end