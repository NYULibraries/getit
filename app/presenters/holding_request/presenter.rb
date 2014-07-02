class HoldingRequest
  class Presenter
    attr_reader :holding_request

    def initialize(holding_request)
      unless(holding_request.is_a?(HoldingRequest))
        raise ArgumentError.new("Expecting #{holding_request} to be a HoldingRequest")
      end
      @holding_request = holding_request
    end
  end
end
