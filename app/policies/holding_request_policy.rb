module Policies
  class HoldingRequestPolicy < Base
    def initialize(holding, user)
      super
    end

    def requestable?
      ill? && available?
    end

    def ill?
      holding.ill?
    end

    def available?
      holding.available? && aleph_user.can_request_available?
    end

    private
    def aleph_user
      @aleph_user ||= AlephUser.new(user)
    end
  end
end
