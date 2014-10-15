class StackMapPolicy
  MAPPABLE_SUB_LIBRARY_CODES = %w[TNSGI]
  MAPPABLE_COLLECTION_CODES = %w[MAIN OVERZ]
  MAPPABLE_LOCATIONS = [
    "New School University Center Main Collection",
    "New School University Center Oversize Collection"
  ]

  attr_reader :holding

  def initialize(holding)
    unless(holding.is_a?(GetIt::Holding::Base))
      raise ArgumentError.new("Expecting #{holding} to be a GetIt::Holding::Base")
    end
    @holding = holding
  end

  def mappable?
    if holding.is_a?(GetIt::Holding::NyuAleph)
      holding.available? &&
        MAPPABLE_SUB_LIBRARY_CODES.include?(sub_library.code) &&
          MAPPABLE_COLLECTION_CODES.include?(collection.code)
    else
      MAPPABLE_LOCATIONS.include?(holding.location)
    end
  end

  private
  def sub_library
    @sub_library ||= holding.sub_library
  end

  def collection
    @collection ||= holding.collection
  end
end
