module HoldingAuthorizer
  class Requestability < Base
    def initialize(holding, user)
      super
    end

    def requestable?
      ill?
    end

    def ill?
      holding.ill?
    end
  end
end
