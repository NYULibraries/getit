module Sfx4
  module Nyu
    module Connection
      def self.included(klass)
        klass.class_eval do
          self.establish_connection :sfx_nyu
        end
      end
    end
  end
end
