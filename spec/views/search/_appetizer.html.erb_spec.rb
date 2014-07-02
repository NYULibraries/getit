require 'rails_helper'
describe 'search/_appetizer' do
  let(:record) { OpenURL::ContextObject.new }
  let(:record_idx) { 1 }
  let(:genre) { 'genre' }
  before do
    record.referent.metadata['genre'] = genre
    render '/search/appetizer', {record: record, record_idx: record_idx}
  end
  subject { rendered }
  it { should match /<strong class="pull-left">1\.<\/strong>/ }
  it { should match /<i class="icons-nyu-content-type-genre">/ }
end
