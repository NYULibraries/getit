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
    'The catcher in the rye' => 'nyu_aleph002268410',
    'The eye of the shah' => 'nyu_aleph004197500',
    'Stolen glimpses, captive shadows' => 'nyu_aleph003774543',
    'America and Europe after 9/11 and Iraq' => 'nyu_aleph000447779',
    'unavailable at NYU' => 'nyu_aleph002422300&url_ver=Z39.88-2004&url_ctx_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Actx&ctx_ver=Z39.88-2004&ctx_tim=2016-08-18T11%3A19%3A20-04%3A00&ctx_id=&ctx_enc=info%3Aofi%2Fenc%3AUTF-8&rft.au=Page%2C+Norman&rft.aufirst=Norman.&rft.aulast=Page&rft.btitle=The+language+of+Jane+Austen.&rft.genre=book&rft.isbn=0064954501&rft.lccn=72195885&rft.place=New+York&rft.primo=nyu_aleph002422300&rft.private_data=<nyu_aleph>002422300<%2Fnyu_aleph><grp_id>198226800<%2Fgrp_id><oa><%2Foa>&rft.pub=Barnes+%26+Noble+Books&rft.title=The+language+of+Jane+Austen.&rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook',
    'unavailable at New School' => 'nyu_aleph002390004&url_ver=Z39.88-2004&url_ctx_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Actx&ctx_ver=Z39.88-2004&ctx_tim=2016-08-18T14%3A39%3A20-04%3A00&ctx_id=&ctx_enc=info%3Aofi%2Fenc%3AUTF-8&rft.au=Edgeworth%2C+Richard+Lovell%2C+1744-1817&rft.aufirst=Richard+Lovell%2C&rft.auinitm=L&rft.aulast=Edgeworth&rft.btitle=Memoirs+of+Richard+Lovell+Edgeworth&rft.genre=book&rft.isbn=0716506041&rft.lccn=75024485&rft.place=Shannon&rft.primo=nyu_aleph002390004&rft.private_data=<nyu_aleph>002390004<%2Fnyu_aleph><grp_id>197995669<%2Fgrp_id><oa><%2Foa>&rft.pub=Irish+University+Press&rft.title=Memoirs+of+Richard+Lovell+Edgeworth&rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook',
    'Algebraic number theory' => 'dedupmrg331545043'

  }
  attr_reader :id, :state
  def initialize(state)
    @state = state
    @id = IDS[state]
  end
end
