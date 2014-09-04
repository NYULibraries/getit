require 'rails_helper'
module GetIt
  describe HoldingManager, vcr: { cassette_name: 'holdings' } do
    describe HoldingManager::VALID_SERVICE_IDS do
      subject { HoldingManager::VALID_SERVICE_IDS }
      it { should eq ['NYU_Primo', 'NYU_Primo_Source'] }
    end
    let(:service_response) { build(:nyu_aleph_service_response) }
    subject(:holding_manager) { HoldingManager.new(service_response) }
    it { should be_a HoldingManager }
    describe '#service_response' do
      subject { holding_manager.service_response }
      it { should be_a ServiceResponse }
      it { should eq service_response }
    end
    describe '#holding' do
      subject { holding_manager.holding }
      context 'when initialized with an "PrimoSource" holding service response' do
        let(:service_response) { build(:primo_source_service_response) }
        it { should be_a Holding::PrimoSource }
        context 'and the holding service response is an "NyuAleph" holding service response' do
          let(:service_response) { build(:nyu_aleph_service_response) }
          it { should be_a Holding::NyuAleph }
        end
      end
      context 'when initialized with an "Primo" holding service response' do
        let(:service_response) { build(:primo_service_response) }
        it { should be_a Holding::Primo }
      end
    end
    context 'when initialized without a service response argument' do
      it 'should raise an ArgumentError' do
        expect { HoldingManager.new }.to raise_error ArgumentError
      end
    end
    context 'when initialized with a service response argument' do
      context 'but the service response argument is not a ServiceResponse' do
        let(:service_response) { 'invalid' }
        it 'should raise an ArgumentError' do
          expect { subject }.to raise_error ArgumentError
        end
      end
      context 'and the service response argument is a ServiceResponse' do
        context 'but the service response argument is not a "holding" ServiceResponse' do
          let(:service_response) { build(:service_response) }
          it 'should raise an ArgumentError' do
            expect { subject }.to raise_error ArgumentError
          end
        end
      end
    end
  end
end
