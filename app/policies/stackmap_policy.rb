class StackMapPolicy
  attr_reader :holding

  def initialize(holding)
    unless(holding.is_a?(GetIt::Holding::Base))
      raise ArgumentError.new("Expecting #{holding} to be a GetIt::Holding::Base")
    end
    @holding = holding
  end
end
