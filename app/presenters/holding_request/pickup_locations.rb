class HoldingRequest
  class PickupLocations < Presenter
    extend Forwardable
    def_delegators :pickup_locations, :each, :size

    include Enumerable

    def pickup_locations
      @pickup_locations ||= circulation_policy.pickup_locations
    end

    def to_a
      map do |pickup_location|
        [pickup_location.display, pickup_location.code]
      end
    end

    private
    def circulation_policy
      @circulation_policy ||= holding_request.circulation_policy
    end
  end
end
