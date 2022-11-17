require 'rails_helper'
describe 'resolve/_holding_response_item' do
  let(:service_response) { create(:nyu_aleph_service_response) }
  let(:requestability) { true }
  let(:current_user) { build(:aleph_user) }
  let(:url_for_request) { "http://url.for.request" }
  subject { rendered }
  before do
    allow(view).to receive(:umlaut_config).and_return(UmlautController.umlaut_config)
    allow(view).to receive(:requestable?).and_return(requestability)
    allow(view).to receive(:current_user).and_return(current_user)
    allow(view).to receive(:url_for_request).and_return(url_for_request)
    render '/resolve/holding_response_item', {service_response: service_response}
  end
  context 'when there is a current user' do
    it { should match /location/ }
    it { should match /NYU Bobst Main Collection/ }
    it { should match /call-number/ }
    it { should match /(DS126 .M62 2002)/ }
    it { should match /status/ }
    it { should match /more-info/ }
    it { should match /More Info/ }
    it { should match /href="\/link_router\/index\/#{service_response.id}/ }
    #it { should match /request-link/ }
    context 'when the holding is not requestable' do
      let(:requestability) { false }
      it { should_not match /request-link/ }
    end
    context 'when the holding is on the shelf' do
      let(:service_response) { create(:on_shelf_nyu_aleph_service_response) }
      it { should match /Available/ }
    end
    context 'when the holding is available' do
      let(:service_response) { create(:available_nyu_aleph_service_response) }
      it { should match /Available/ }
    end
    context 'when the holding is checked out' do
      let(:service_response) { create(:checked_out_nyu_aleph_service_response) }
      it { should match /Due: 06\/28\/14/ }
    end
    context 'when the holding is offsite' do
      let(:service_response) { create(:offsite_nyu_aleph_service_response) }
      it { should match /Offsite Available/ }
    end
    context 'when the holding is billed as lost' do
      let(:service_response) { create(:billed_as_lost_nyu_aleph_service_response) }
      it { should match /Request ILL/ }
    end
    context 'when the holding is claimed returned' do
      let(:service_response) { create(:claimed_returned_nyu_aleph_service_response) }
      it { should match /Request ILL/ }
    end
    context 'when the holding requires ILLing' do
      let(:service_response) { create(:ill_nyu_aleph_service_response) }
      it { should match /Request ILL/ }
    end
    context 'when the holding is reshelving' do
      let(:service_response) { create(:reshelving_nyu_aleph_service_response) }
      it { should match /Reshelving/ }
    end
    context 'when the holding is being processed' do
      let(:service_response) { create(:processing_nyu_aleph_service_response) }
      it { should match /In Processing/ }
    end
    context 'when the holding is in transit' do
      let(:service_response) { create(:transit_nyu_aleph_service_response) }
      it { should match /In Processing/ }
    end
    context 'when the holding is on order' do
      let(:service_response) { create(:on_order_nyu_aleph_service_response) }
      it { should match /On Order/ }
    end
  end
  context 'when the current user is nil' do
    let(:current_user) { nil }
    it { should match /location/ }
    it { should match /NYU Bobst Main Collection/ }
    it { should match /call-number/ }
    it { should match /(DS126 .M62 2002)/ }
    it { should match /status/ }
    it { should match /more-info/ }
    it { should match /More Info/ }
    it { should match /href="\/link_router\/index\/#{service_response.id}/ }
    #it { should match /request-login-link/ }
  end
  context 'when the holding is expired' do
    let(:service_response) { create(:expired_nyu_aleph_service_response) }
    it { should_not match /location/ }
    it { should_not match /NYU Bobst Main Collection/ }
    it { should_not match /call-number/ }
    it { should_not match /(DS126 .M62 2002)/ }
    it { should_not match /status/ }
    it { should_not match /more-info/ }
    it { should_not match /More Info/ }
    it { should_not match /href="\/link_router\/index\/#{service_response.id}/ }
    it { should_not match /request-link/ }
    it { should_not match /request-login-link/ }
  end
end
