require 'rails_helper'
class HoldingRequest
  describe Options, vcr: {cassette_name: 'holding_requests/options'} do
    let(:service_response) { build(:nyu_aleph_service_response) }
    let(:holding) { GetIt::Holding::NyuAleph.new(service_response)}
    let(:user) { build(:aleph_user) }
    let(:holding_request) { HoldingRequest.new(holding, user) }
    subject(:options) { Options.new(holding_request) }
    it { should be_a Presenter }
    it { should be_an Options }
    describe '#authorizer' do
      subject { options.authorizer }
      it { should be_a HoldingRequest::Authorizer }
    end
    describe '#size' do
      subject { options.size }
      it { should be_an Integer }
      context 'when the holding is in an "ILL" state' do
        let(:service_response) { build(:ill_nyu_aleph_service_response) }
        it { should be 1 }
      end
      context 'when the holding is in an "available" state' do
        let(:service_response) { build(:available_nyu_aleph_service_response) }
        it { should be 2 }
      end
      context 'when the holding is "offsite"' do
        let(:service_response) { build(:offsite_nyu_aleph_service_response) }
        it { should be 2 }
      end
      context 'when the holding is "checked out"' do
        let(:service_response) { build(:checked_out_nyu_aleph_service_response) }
        it { should be 2 }
      end
      context 'when the holding is "requested"' do
        let(:service_response) { build(:requested_nyu_aleph_service_response) }
        it { should be 2 }
      end
      context 'when the holding is "requested"' do
        let(:service_response) { build(:on_order_nyu_aleph_service_response) }
        it { should be 2 }
      end
      context 'when the holding is "billed as lost"' do
        let(:service_response) { build(:billed_as_lost_nyu_aleph_service_response) }
        it { should be 1 }
      end
    end
  end
end
