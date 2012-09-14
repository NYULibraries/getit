module Sfx4
  module Ns
    module Connection
      def self.included(klass)
        klass.class_eval do
          self.establish_connection :sfx_ns
        end
      end
    end
  end
end
