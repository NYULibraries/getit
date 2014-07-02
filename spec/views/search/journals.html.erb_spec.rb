require 'rails_helper'
describe 'search/journals' do
  let(:current_primary_institution) { Institutions.institutions[:NYU] }
  before do
    allow(view).to receive(:current_primary_institution).and_return(current_primary_institution)
    render
  end
  subject { rendered }
  it { should match /<div class="search with-tabs">/ }
  it { should render_template 'search/_form' }
  it { should render_template 'search/_browse' }
end
