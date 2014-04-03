module HoldingAuthorizer
  class Base
    attr_reader :holding, :user
    def initialize(holding, user=nil)
      unless(holding.is_a?(Holding))
        raise ArgumentError.new("Expecting #{holding} to be a Holding")
      end
      unless(user.nil? || user.is_a?(User))
        raise ArgumentError.new("Expecting #{user} to be a User")
      end
      @holding = holding
      @user = user
    end
  end
end
