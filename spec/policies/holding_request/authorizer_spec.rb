# A HoldingRequest::Authorizer takes a HoldingRequest
# and determines whether the holding/user combination
# is authorized for a given action.
require 'rails_helper'
class HoldingRequest
  describe Authorizer, vcr: {cassette_name: 'holding_requests/authorizer'} do
    let(:service_response) { build(:nyu_aleph_service_response) }
    let(:holding) { GetIt::Holding::NyuAleph.new(service_response) }
    let(:user) { build(:aleph_user) }
    let(:holding_request) { HoldingRequest.new(holding, user) }
    subject(:authorizer) { HoldingRequest::Authorizer.new(holding_request) }
    it { should be_a HoldingRequest::Authorizer }
    describe '#requestable?' do
      subject { authorizer.requestable? }
      context 'when the holding is in an requestable state' do
        let(:service_response) { build(:ill_nyu_aleph_service_response) }
        it { should be true }
      end
      context 'when the holding is not in a requestable state' do
        let(:service_response) { build(:reshelving_nyu_aleph_service_response) }
        it { should be false }
      end
    end
    describe '#available?' do
      subject { authorizer.available? }
      context 'when the holding is in an "available" state' do
        let(:service_response) { build(:available_nyu_aleph_service_response) }
        context 'but the user does not have rights to request holdings in this sublibrary' do
          xit { should be false }
        end
        context 'and the user does have rights to request holdings in this sublibrary' do
          context 'but the user does not have rights to request holdings that are "available"' do
            xit { should be false }
          end
          context 'and the user has rights to request holdings that are "On Shelf"' do
            it { should be true }
          end
        end
      end
      context 'when the holding is in a non "available" state' do
        let(:service_response) { build(:ill_nyu_aleph_service_response) }
        it { should be false }
      end
    end
    describe '#recallable?' do
      subject { authorizer.recallable? }
      context 'when the holding is in a "recallable" state' do
        let(:service_response) { build(:checked_out_nyu_aleph_service_response) }
        context 'but the user does not have rights to request holdings in this sublibrary' do
          xit { should be false }
        end
        context 'and the user does have rights to request holdings in this sublibrary' do
          it { should be true }
        end
      end
      context 'when the holding is in a non "recallable" state' do
        let(:service_response) { build(:ill_nyu_aleph_service_response) }
        it { should be false }
      end
    end
    describe '#offsite?' do
      subject { authorizer.offsite? }
      context 'when the holding is in an "offsite" state' do
        let(:service_response) { build(:offsite_nyu_aleph_service_response) }
        context 'but the user does not have rights to request holdings in this sublibrary' do
          xit { should be false }
        end
        context 'and the user does have rights to request holdings in this sublibrary' do
          it { should be true }
        end
      end
      context 'when the holding is in a non "offsite" state' do
        let(:service_response) { build(:ill_nyu_aleph_service_response) }
        it { should be false }
      end
    end
    describe '#processing?' do
      subject { authorizer.processing? }
      context 'when the holding is in a "processing" state' do
        let(:service_response) { build(:processing_nyu_aleph_service_response) }
        context 'but the user does not have rights to request holdings in this sublibrary' do
          xit { should be false }
        end
        context 'and the user does have rights to request holdings in this sublibrary' do
          it { should be true }
        end
      end
      context 'when the holding is in a non "processing" state' do
        let(:service_response) { build(:ill_nyu_aleph_service_response) }
        it { should be false }
      end
    end
    describe '#on_order?' do
      subject { authorizer.on_order? }
      context 'when the holding is in a "on order" state' do
        let(:service_response) { build(:on_order_nyu_aleph_service_response) }
        context 'but the user does not have rights to request holdings in this sublibrary' do
          xit { should be false }
        end
        context 'and the user does have rights to request holdings in this sublibrary' do
          it { should be true }
        end
      end
      context 'when the holding is in a non "on order" state' do
        let(:service_response) { build(:ill_nyu_aleph_service_response) }
        it { should be false }
      end
    end
    describe '#ill?' do
      subject { authorizer.ill? }
      context 'when the holding is in an ILL state' do
        let(:service_response) { build(:ill_nyu_aleph_service_response) }
        it { should be true }
      end
      context 'when the holding is in an available state' do
        let(:service_response) { build(:available_nyu_aleph_service_response) }
        it { should be false }
      end
    end
    context 'when initialized without any arguments' do
      it 'should raise an ArgumentError' do
        expect { HoldingRequest::Authorizer.new }.to raise_error ArgumentError
      end
    end
    context 'when initialized with a holding request argument' do
      context 'but the holding request argument is not a HoldingRequest' do
        let(:holding_request) { "invalid" }
        it 'should raise an ArgumentError' do
          expect { subject }.to raise_error ArgumentError
        end
      end
    end
  end
end
