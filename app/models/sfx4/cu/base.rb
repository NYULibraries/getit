module Sfx4
  module Cu
    class Base < ActiveRecord::Base
      # This model is readonly.
      # Don't whitelist any attributes
      attr_accessible

      # Was a SFX DB connection set in database.yml to connect directly to sfx?
      def self.connection_configured?
        config = ActiveRecord::Base.configurations["sfx4_cu"]
        (not (config.nil? or config.blank? or config["adapter"].blank?))
      end

      self.establish_connection :sfx4_cu if self.connection_configured?

      # ActiveRecord likes it when we tell it this is an abstract
      # class only. 
      self.abstract_class = true 

      extend Sfx4::Abstract::Base

      # All SFX things are read-only!
      def readonly?() 
        return true
      end
    end
  end
end
