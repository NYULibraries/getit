class HoldingRequest
  class Options < Presenter
    attr_reader :authorizer

    def initialize(holding_request)
      super
      @authorizer = HoldingRequest::Authorizer.new(holding_request)
    end

    def size
      @size ||= begin
        size = 0
        size += 2 if authorizer.available?
        size += 1 if authorizer.recall?
        size += 1 if authorizer.processing?
        size += 1 if authorizer.on_order?
        size += 2 if authorizer.offsite?
        size += 1 if authorizer.ill?
        size
      end
    end
  end
end
