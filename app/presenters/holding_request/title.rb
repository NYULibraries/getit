class HoldingRequest
  class Title < Presenter
    attr_reader :holding

    def initialize(holding_request)
      super
      @holding = holding_request.holding
    end

    def value
      @value ||= "\"#{title}\" is " + begin
        case
        when status.requested?
          'requested'
        when status.checked_out?
          'checked out'
        when status.available?
          "available at #{sub_library}"
        when status.offsite?
          "available from the #{sub_library} offsite storage facility"
        when status.processing?
          'currently being processed by library staff'
        when holding.on_order?
          'on order'
        when holding.ill?
          'currently out of circulation'
        end
      end.to_s + '.'
    end
    alias_method :to_s, :value

    private
    def sub_library
      @sub_library ||= holding.sub_library
    end

    def status
      @status ||= holding.status
    end

    def service_response
      @service_response ||= holding.service_response
    end

    def request
      @request ||= service_response.request
    end

    def referent
      @referent ||= request.referent.reload
    end

    def citation
      @citation ||= referent.to_citation
    end

    def title
      @title ||= citation[:title].to_s
    end
  end
end
