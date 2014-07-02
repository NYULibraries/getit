require 'rails_helper'
module GetIt
  module Holding
    describe Primo do
      let(:service_response) { build(:primo_service_response) }
      subject(:holding) { Primo.new(service_response) }
      it { should be_a Base }
      it { should be_a Primo }
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
        context 'but the service response argument is not an "NYU_Primo" ServiceResponse' do
          let(:service_response) { build(:holding_service_response) }
          it 'should raise an ArgumentError' do
            expect { subject }.to raise_error ArgumentError
          end
        end
      end
    end
  end
end
