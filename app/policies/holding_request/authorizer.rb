class HoldingRequest
  class Authorizer
    attr_reader :holding_request

    def initialize(holding_request)
      unless(holding_request.is_a?(HoldingRequest))
        raise ArgumentError.new("Expecting #{holding_request} to be a HoldingRequest")
      end
      @holding_request = holding_request
    end

    # Status is requestable if the Holding is in an
    # ILL state or the combination of User and Holding
    # is requestable
    def requestable?
      (ill? || available? || recallable? || scannable? ||
        processing? || on_order? || offsite?)
    end

    def scannable?
      holding.scannable?
    end

    def ezborrow?
      holding.ill? && ezborrow_authorizer.authorized?
    end

    def ill?
      holding.ill? && ill_authorizer.authorized?
    end

    def available?

      holding.available? && privileges.hold_request?
    end

    def recallable?
      (holding.checked_out? || holding.requested?) && privileges.hold_request? && !ill? && !ezborrow?
    end
    alias_method :recall?, :recallable?

    def offsite?
      holding.offsite? && privileges.hold_request?
    end

    def processing?
      holding.processing? && privileges.hold_request?
    end

    def on_order?
      holding.on_order? && privileges.hold_request?
    end

    private
    extend Forwardable
    # Delegate holding and user instance methods to the @holding_request
    def_delegators :@holding_request, :holding, :user, :aleph_patron

    def privileges
      @privileges ||= circulation_policy.privileges
    end

    def circulation_policy
      @circulation_policy ||= holding_request.circulation_policy
    end

    def ezborrow_authorizer
      @ezborrow_authorizer ||= EZBorrowAuthorizer.new(user)
    end

    def ill_authorizer
      @ill_authorizer ||= ILLAuthorizer.new(user)
    end
  end
end
