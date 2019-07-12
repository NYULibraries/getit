require 'rails_helper'
describe 'search/journal_search' do
  let(:current_primary_institution) { Institutions.institutions[:NYU] }
  let(:batch_size) { 20 }
  let(:hits) { 0 }
  let(:display_results) { [] }
  before do
    assign(:batch_size, batch_size)
    assign(:hits, hits)
    assign(:display_results, display_results)
    allow(view).to receive(:current_primary_institution).and_return(current_primary_institution)
    render
  end
  subject { rendered }
  it { should match /<div class="search with-tabs">/ }
  it { should render_template 'search/_pager' }
  context 'when there are no results' do
    let(:hits) { 0 }
    let(:display_results) { [] }
    it { should_not render_template 'search/_record' }
  end
end
