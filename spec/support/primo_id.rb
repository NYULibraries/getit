class PrimoId
  PRIMO_REFERRER_ID_BASE = 'info:sid/primo.exlibrisgroup.com:primo-'
  IDS = {
    'journal' => 'nyu_aleph002736245',
    'Vogue' => 'nyu_aleph002893728',
    'The New Yorker' => 'nyu_aleph002904404',
    'Not by Reason Alone' => 'nyu_aleph002104209',
    'The body as home' => 'COURSES000243396',
    'book' => 'nyu_aleph001102376',
    'checked out' => 'nyu_aleph003562911',
    'requested' => 'nyu_aleph000864162',
    'offsite' => 'nyu_aleph002928667',
    'available' => 'nyu_aleph001102376',
    'processing' => 'nyu_aleph003933870',
    'on_order' => 'NEEDED',
    'ill' => 'nyu_aleph000762323',
    'Overcoming trauma through yoga' => 'dedupmrg200192935',
    'Gothic architecture' => 'nyu_aleph002517067',
    'El Croquis' => 'nyu_aleph002106230',
    'To kill a mockingbird [videorecording]' => 'nyu_aleph001624317',
    'Franny and Zooey' => 'nyu_aleph000679305',
    'The catcher in the rye' => 'nyu_aleph002268410'
  }
  attr_reader :id, :state
  def initialize(state)
    @state = state
    @id = IDS[state]
  end
end
