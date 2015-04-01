class StackMapPresenter
  MAPPABLE_LIBRARIES = ["TNS University Center Library"]

  attr_reader :holding

  def initialize(holding)
    unless(holding.is_a?(GetIt::Holding::NyuAleph))
      raise ArgumentError.new("Expecting #{holding} to be a GetIt::Holding::NyuAleph")
    end
    @holding = holding
  end

  def call_number
    @call_number ||= "#{holding.call_number}".gsub(/[\(\)]/, '').strip
  end

  def location
    @location ||= begin
      if from_aleph?
        "#{holding.collection}"
      else
        holding.location.sub(/#{mappable_library}/, '').strip
      end
    end
  end

  def library
    @library ||= begin
      if from_aleph?
        "#{holding.sub_library}"
      else
        mappable_library
      end
    end
  end

  def prefix
    @prefix ||= 'newschool'
  end

  private
  def from_aleph?
    holding.is_a? GetIt::Holding::NyuAleph
  end

  def mappable_library
    @mappable_library ||= MAPPABLE_LIBRARIES.find do |library|
      Regexp.new("^#{library}") === holding.location
    end
  end
end
