class HoldingRequest
  class Authorizer
    EZBORROW_BOR_STATUSES =
      %w{20 21 22 23 50 51 52 53 54 55 56 57 58 60 61 62 63 65 66 80 81 82}

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
      (ill? || available? || recallable? ||
        processing? || on_order? || offsite?)
    end

    def ezborrow?
      holding.ill? && EZBORROW_BOR_STATUSES.include?(aleph_patron.bor_status)
    end

    def ill?
      holding.ill?
    end

    def available?
      holding.available? && privileges.hold_request?
    end

    def recallable?
      (holding.checked_out? || holding.requested?) && privileges.hold_request?
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
    def_delegators :@holding_request, :holding, :aleph_patron

    def privileges
      @privileges ||= circulation_policy.privileges
    end

    def circulation_policy
      @circulation_policy ||= holding_request.circulation_policy
    end
  end
end
