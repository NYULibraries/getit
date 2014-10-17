class StackMapPolicy
  MAPPABLE_SUB_LIBRARY_CODES = %w[TNSGI]
  MAPPABLE_COLLECTION_CODES = %w[MAIN OVERZ]

  attr_reader :holding

  def initialize(holding)
    unless(holding.is_a?(GetIt::Holding::NyuAleph))
      raise ArgumentError.new("Expecting #{holding} to be a GetIt::Holding::NyuAleph")
    end
    @holding = holding
  end

  def mappable?
    if holding.from_aleph?
      holding.available? && location_mappable?
    else
      location_mappable?
    end
  end

  private
  def location_mappable?
    MAPPABLE_SUB_LIBRARY_CODES.include?(sub_library.code) &&
      MAPPABLE_COLLECTION_CODES.include?(collection.code)
  end

  def sub_library
    @sub_library ||= holding.sub_library
  end

  def collection
    @collection ||= holding.collection
  end
end
