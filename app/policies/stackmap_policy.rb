class StackMapPolicy
  MAPPABLE_INSTITUTION_CODES = %w[NS]
  MAPPABLE_SUB_LIBRARY_CODES = %w[TNSGI TNSFO TNSSC]
  MAPPABLE_COLLECTION_CODES = %w[MAIN MINI MUREF MUSIC OVERM OVERZ REF SCORE]

  attr_reader :holding

  def self.mappable_institution?(institution)
    MAPPABLE_INSTITUTION_CODES.include?(institution)
  end

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
