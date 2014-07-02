require 'rails_helper'
describe 'resolve/_holding_response_item' do
  let(:service_response) { create(:nyu_aleph_service_response) }
  let(:request) { service_response.request }
  let(:requestability) { true }
  let(:current_user) { build(:aleph_user) }
  let(:url_for_request) { "http://url.for.request" }
  let(:holding) { [service_response] }
  subject { rendered }
  before do
    assign(:user_request, request)
    allow(view).to receive(:current_primary_institution).and_return(Institutions.institutions[:NYU])
    allow(view).to receive(:umlaut_config).and_return(UmlautController.umlaut_config)
    allow(view).to receive(:requestable?).and_return(requestability)
    allow(view).to receive(:current_user).and_return(current_user)
    allow(view).to receive(:url_for_request).and_return(url_for_request)
    render '/resolve/holding', {holding: holding}
  end
  it { should match /umlaut-holdings/ }
  it { should match /View Maps and Call Number Locations/ }
  it { should match /href="http:\/\/library\.nyu\.edu\/bobcat\/callno\/"/ }
  context 'when the holdings are empty' do
    let(:holding) { [] }
    it { should_not match /umlaut-holdings/ }
    it { should_not match /View Maps and Call Number Locations/ }
    it { should_not match /href="http:\/\/library\.nyu\.edu\/bobcat\/callno\/"/ }
    it { should match /umlaut-unavailable/ }
    it { should match /Not Available/ }
  end
end

