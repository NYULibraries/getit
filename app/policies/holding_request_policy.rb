module Policies
  class HoldingRequestPolicy < Base
    def initialize(holding, user)
      super
    end

    def requestable?
      ill?
    end

    def available?
    end

    def ill?
      holding.ill?
    end
  end
end
