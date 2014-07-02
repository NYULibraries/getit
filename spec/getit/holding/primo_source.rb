require 'rails_helper'
module GetIt
  module Holding
    describe PrimoSource do
      let(:service_response) { build(:primo_source_service_response) }
      subject(:holding) { PrimoSource.new(service_response) }
      it { should be_a Base }
      it { should be_a PrimoSource }
      describe '#service_response' do
        subject { holding.service_response }
        it { should be_a ServiceResponse }
        it { should be service_response }
      end
      describe '#location' do
        subject { holding.location}
        it { should_not be_nil }
      end
      describe '#call_number' do
        subject { holding.call_number}
        it { should_not be_nil }
      end
      describe '#status' do
        subject { holding.status}
        it { should_not be_nil }
      end
      describe '#edition' do
        subject { holding.edition}
        it { should_not be_nil }
      end
      describe '#notes' do
        subject { holding.notes}
        it { should_not be_nil }
      end
      describe '#coverage' do
        subject { holding.coverage}
        it { should_not be_nil }
      end
      describe '#reliability' do
        subject { holding.reliability}
        it { should_not be_nil }
      end
      context 'when initialized with a service response argument' do
        context 'but the service response argument is not an "NYU_Primo_Source" ServiceResponse' do
          let(:service_response) { build(:holding_service_response) }
          it 'should raise an ArgumentError' do
            expect { subject }.to raise_error ArgumentError
          end
        end
        context 'and the service response argument is an "NYU_Primo_Source" ServiceResponse' do
          context 'but the service response argument does not have source data' do
            let(:service_response) { build(:nyu_aleph_service_response_without_source_data) }
            it 'should raise an ArgumentError' do
              expect { subject }.to raise_error ArgumentError
            end
          end
        end
      end
    end
  end
end
