require 'rails_helper'
describe SearchController, vcr: {cassette_name: 'search'}  do

  let(:jtitle) { "The New Yorker" }
  let(:title_search_type) { "exact" }
  let(:object_id) { '1000000000237705' }
  let(:institution) { 'NS' }

  describe 'GET /search/journal_search' do
    before { get :journal_search, "rft.jtitle" => jtitle, "umlaut.title_search_type" => title_search_type, "rft.object_id" => object_id, "umlaut.institution" => institution }
    subject { response.location }
    it { should include 'umlaut.institution=NS' }
    it { should include 'rft.object_id=1000000000237705' }
    it { should include 'rft.jtitle=The+New+Yorker' }
  end

  describe 'GET /search' do
    before do
      get :index, "umlaut.institution" => institution
    end
    subject { response }
    its(:status) { is_expected.to eql 301 }
    context 'when institution is NYU' do
      let(:institution) { 'NYU' }
      it { is_expected.to redirect_to 'http://bobcatdev.library.nyu.edu/primo-explore/citationlinker?vid=NYU' }
    end
    context 'when institution is NYUAD' do
      let(:institution) { 'NYUAD' }
      it { is_expected.to redirect_to 'http://bobcatdev.library.nyu.edu/primo-explore/citationlinker?vid=NYUAD' }
    end
    context 'when institution is NYUSH' do
      let(:institution) { 'NYUSH' }
      it { is_expected.to redirect_to 'http://bobcatdev.library.nyu.edu/primo-explore/citationlinker?vid=NYUSH' }
    end
    context 'when institution is CU' do
      let(:institution) { 'CU' }
      it { is_expected.to redirect_to 'http://bobcatdev.library.nyu.edu/primo-explore/citationlinker?vid=CU' }
    end
    context 'when institution is NS' do
      let(:institution) { 'NS' }
      it { is_expected.to redirect_to 'http://bobcatdev.library.nyu.edu/primo-explore/citationlinker?vid=NS' }
    end
  end
end
