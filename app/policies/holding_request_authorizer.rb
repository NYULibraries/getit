module Policies
  class HoldingRequestAuthorizer < Base
    def initialize(holding, user)
      super
    end

    # Status is requestable if the Holding is in an 
    # ILL state or the combination of User and Holding
    # is requestable
    def requestable?
      (ill? || available? || recallable? ||
        processing? || on_order? || offsite?)
    end

    def ill?
      holding.ill?
    end

    def available?
      combo_requestable? && holding.available? && user_can_request_available?
    end

    def recallable?
      combo_requestable? && holding.recallable?
    end
    alias_method :recall?, :recallable?

    def offsite?
      combo_requestable? && holding.offsite?
    end

    def processing?
      combo_requestable? && holding.processing?
    end
    alias_method :in_processing?, :processing?

    def on_order?
      combo_requestable? && holding.on_order?
    end

    private
    def combo_requestable?
      always_requestable? || (holding.requestable? && user_can_request?)
    end

    def always_requestable?
      holding.always_requestable? && aleph_user.nil?
    end

    def user_can_request?
      aleph_user.present? && aleph_user.can_request?(holding)
    end

    def user_can_request_available?
      aleph_user.present? && aleph_user.can_request_available?(holding)
    end

    def aleph_user
      @aleph_user ||= AlephUser.new(user) unless user.nil?
    end
  end
end
