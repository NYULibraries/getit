module GetItFeatures
  class Item
    IDS = {
      'checked out' => 'nyu_aleph000741245',
      'requested' => 'nyu_aleph003337878',
      'offsite' => 'nyu_aleph002928667',
      'available' => 'nyu_aleph000012712',
      'ill' => 'nyu_aleph000762323'
    }
    attr_reader :id, :type
    def initialize(type)
      @type = type
      @id = IDS[type]
    end
  end
end
