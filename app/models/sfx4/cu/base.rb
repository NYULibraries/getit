module Sfx4
  module Cu
    class Base < ActiveRecord::Base
      self.establish_connection :sfx4_cu
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
