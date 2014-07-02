require 'rails_helper'
describe 'search/_entree' do
  let(:record) { OpenURL::ContextObject.new }
  let(:jtitle) { 'Journal Title' }
  let(:current_primary_institution) { Institutions.institutions[:NYU] }
  let(:url_for_with_co) { 'http://url.for.with.co' }
  before do
    record.referent.metadata['jtitle'] = jtitle
    allow(view).to receive(:current_primary_institution).and_return(current_primary_institution)
    allow(view).to receive(:url_for_with_co).and_return(url_for_with_co)
    render '/search/entree', {record: record}
  end
  subject { rendered }
  it { should match /<h2 class="title"><a href="http:\/\/url\.for\.with\.co" target="_blank">Journal Title/ }
end
