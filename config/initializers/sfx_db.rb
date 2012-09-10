module SfxDb
  # Was an sfx_db connection set in database.yml to connect
  # directly to sfx? or was the input spec specified correctly?
  def self.connection_configured?(spec = :sfx_db)
    config = SfxDb::Object.with_connection(spec).connection.instance_variable_get(:@config)
    return (!config.blank? && !config[:adapter].blank?)    
  end

  class SfxDbBase < ActiveRecord::Base
    NO_CONNECTION_DEFINED = 
        "SfxDb classes require you to specify a database connection called sfx_db in your config/umlaut_config/databases.yml.\n" + 
        "Alternatively or in conjunction, you can specify an sfx_db connection in your config/umlaut_config/institutions.yml\n"

    def self.with_connection(spec = :sfx_db)
        raise RuntimeError.new("Unsupported operation. :with_connection is not supported for SfxDbBase.") if self.eql?(SfxDbBase)
        # Dynamically create the class and store it for future use
        create_dynamic_class(self, create_dynamic_class(SfxDbBase, SfxDbBase, spec), spec)
    end
    
    def self.create_dynamic_class(baseclass, superclass, spec)
        # raise ArgumentError.new("Unsupported operation. :create_dynamic_class is only supported for SfxDb.")
        raise ArgumentError.new("#{NO_CONNECTION_DEFINED}") if spec.nil?
        dynamic_class_name = dynamic_class_name(baseclass, spec)
        # Return the class if it exists
        return SfxDb.const_get(dynamic_class_name) if SfxDb.const_defined?(dynamic_class_name)
        # Create a new dynamic class from the super class.
        dynamic_class = Class.new(superclass)
        # Set the constant name in the SfxDb module
        SfxDb.const_set(dynamic_class_name, dynamic_class)
        if (baseclass.eql?(SfxDbBase))
            dynamic_class.establish_connection(spec)
        else
            # Add table name and primary key
            raise NameError.new("Base classes must define self.table_name for dynamic class creation.") if baseclass.table_name.nil?
            dynamic_class.table_name = baseclass.table_name
            raise NameError.new("Base classes must define self.primary_key for dynamic class creation.") if baseclass.primary_key.nil?
            dynamic_class.primary_key = baseclass.primary_key
            # Process associations
            baseclass.reflect_on_all_associations.each do |association|
                # TODO: Make it guess the class name if it's not defined
                raise NameError.new("Associations must define :class_name for dynamic mapping.") if association.options[:class_name].nil?
                association_dynamic_class = 
                    create_dynamic_class(association.options[:class_name].constantize, superclass, spec)
                options = association.options.merge({:class_name => association_dynamic_class.name})
                dynamic_class.send(association.macro, association.name, options)
            end
        end
        dynamic_class
    end
    
    def self.dynamic_class_name(baseclass, spec)
        dynamic_class_name = "Dynamic#{baseclass.name.split('::').last}"
        case spec
        when Symbol, String
            dynamic_class_name << "#{spec.to_s.capitalize}"
        else
            spec = spec.symbolize_keys
            dynamic_class_name << "#{spec[:host].split('.').collect{|s| s.capitalize}.join}" +
                "#{spec[:port]}#{spec[:database].capitalize}"
        end    
    end
    
    def self.establish_connection(spec = :sfx_db)
        begin
            super(spec)
        rescue ActiveRecord::ActiveRecordError => e
            new_e = e.class.new(e.message + ":\n#{NO_CONNECTION_DEFINED}")
            new_e.set_backtrace( e.backtrace )
            raise new_e 
        end
    end
    
    # This guy uses a different db connection. We can establish that here, on
    # class-load. Please define an sfx_db database in databases.yml!
    # Some utility methods are also located in this class. 
    # self.establish_connection

    # All SfxDb things are read-only!
    def readonly?() 
      return true
    end
    
    def to_context_object
      raise RuntimeError.new("Unsupported operation. :to_context_object is not supported for objects other than AzTitles.") unless self.class.name.match(/AzTitle/)
      co = OpenURL::ContextObject.new
      # Make sure it uses a journal type referent please, that's what we've
      # got here.
      co.referent = OpenURL::ContextObjectEntity.new_from_format( 'info:ofi/fmt:xml:xsd:journal' )
      co.referent.set_metadata('jtitle', self.TITLE_DISPLAY)
      co.referent.set_metadata('object_id', self.OBJECT_ID.to_s)
      # Add publisher stuff, if possible.
      pub = self.object ? self.object.publishers.first : nil
      if ( pub )
        co.referent.set_metadata('pub', pub.PUBLISHER_DISPLAY )
        co.referent.set_metadata('place', pub.PLACE_OF_PUBLICATION_DISPLAY)
      end      
      return co
    end

    # Atttempts to extract all URLs that SFX knows about from the db.
    # This process is not 100%, becuase of the way SFX calculates URLs
    # on the fly. We are only grabbing them from the db--and even the
    # way they are stored in the db is hard for us to grab reliably!
    # So this is really just a kind of guess heuristic in a bunch
    # of ways. 
    # But we do our best, and use this to load the SfxUrl model. 
    def self.fetch_sfx_urls
        # Fetch all target services that look like they might have a URL
        # in the parse param, and that are active. We know this misses ones
        # that are just active for certain institutes! Known defect.
        target_services = TargetService.with_connection(connection.instance_variable_get(:@config)).find(:all, :conditions => "PARSE_PARAM like '%.%' and AVAILABILITY ='ACTIVE'")

        # Same with object portfolios, which can also have urls hidden in em
        object_portfolios = ObjectPortfolio.with_connection(connection.instance_variable_get(:@config)).find(:all, :conditions => "PARSE_PARAM like '%.%' and AVAILABILITY = 'ACTIVE'")

        urls = []
        (target_services + object_portfolios).each do |db_row|
          parse_param = db_row.PARSE_PARAM

          # Try to get things that look sort of like URLs out. Brutal force,
          # sorry. 
          url_re = Regexp.new('(https?://\S+\.\S+)(\s|$)')
          urls.concat( parse_param.scan( url_re ).collect {|matches| matches[0]} )
          
        end
        urls.uniq!
        return urls        
    end
  end

  class Target < SfxDbBase
    has_many :target_services,
             :foreign_key => 'TARGET',
             :class_name => "SfxDb::TargetService"
  end
end