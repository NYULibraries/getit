class PrimoId
  PRIMO_REFERRER_ID_BASE = 'info:sid/primo.exlibrisgroup.com:primo-'
  IDS = {
    'checked out' => 'nyu_aleph000741245',
    'requested' => 'nyu_aleph003337878',
    'offsite' => 'nyu_aleph002928667',
    'available' => 'nyu_aleph000012712',
    'ill' => 'nyu_aleph000762323'
  }
  attr_reader :id, :state
  def initialize(state)
    @state = state
    @id = IDS[state]
  end
end
