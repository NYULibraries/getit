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
end
