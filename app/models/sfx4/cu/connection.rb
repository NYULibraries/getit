module Sfx4
  module Cu
    module Connection
      def self.included(klass)
        klass.class_eval do
          self.establish_connection :sfx_cu
        end
      end
    end
  end
end
