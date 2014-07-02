require 'rails_helper'
describe 'search/_record' do
  let(:record) { OpenURL::ContextObject.new }
  let(:record_idx) { 1 }
  before do
    render '/search/record', {record: record, record_idx: record_idx}
    it { should match /<div class="result row-fluid">/ }
    it { should match /<div class="span1 appetizer">/ }
    it { should render_template 'search/_appetizer' }
    it { should match /<div class="span11 entree">/ }
    it { should render_template 'search/_entree' }
  end
end
