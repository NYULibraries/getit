require 'rails_helper'
module GetIt
  module Holding
    describe Base do
      let(:service_response) { build(:holding_service_response) }
      subject(:holding) { Base.new(service_response) }
      it { should be_a Base }
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
      describe '#title' do
        subject { holding.title}
        it { should_not be_nil }
      end
      describe '#expired?' do
        subject { holding.expired?}
        it { should be false }
      end
      describe '#expire!' do
        subject { holding.expire! }
        it 'should be expired' do
          subject
          expect(holding.expired?).to be true
        end
        it 'should be reflected in the service response' do
          subject
          expect(service_response.view_data[:expired]).to be true
        end
        it 'should saved to the database via the service response' do
          subject
          service_response.reload
          expect(service_response.view_data[:expired]).to be true
        end
      end
      context 'when initialized without any arguments' do
        it 'should raise an ArgumentError' do
          expect { Base.new }.to raise_error ArgumentError
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
end
