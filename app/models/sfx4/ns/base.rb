module Sfx4
  module Ns
    class Base < ActiveRecord::Base

      # Was a SFX DB connection set in database.yml to connect directly to sfx?
      def self.connection_configured?
        config = ActiveRecord::Base.configurations["sfx4_ns"]
        (not (config.nil? or config.blank? or config["adapter"].blank?))
      end

      self.establish_connection :sfx4_ns if self.connection_configured?

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
