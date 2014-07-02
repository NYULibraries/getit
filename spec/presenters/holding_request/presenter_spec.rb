require 'rails_helper'
class HoldingRequest
  describe Presenter do
    let(:service_response) { build(:nyu_aleph_service_response) }
    let(:holding) { GetIt::Holding::NyuAleph.new(service_response)}
    let(:user) { build(:aleph_user) }
    let(:holding_request) { HoldingRequest.new(holding, user) }
    subject(:presenter) { HoldingRequest::Presenter.new(holding_request) }
    it { should be_a Presenter }
    describe '#holding_request' do
      subject { presenter.holding_request }
      it { should be_a HoldingRequest }
      it { should be holding_request }
    end
    context 'when initialized without any arguments' do
      it 'should raise an ArgumentError' do
        expect { HoldingRequest::Options.new }.to raise_error ArgumentError
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
