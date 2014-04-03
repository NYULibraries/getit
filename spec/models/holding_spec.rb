require 'spec_helper'
describe Holding do
  let(:service_response) { create(:service_response) }
  subject(:holding) { Holding.new(service_response) }
  it { should be_a Holding }
  context 'when initialized without any arguments' do
    it 'should raise an ArgumentError' do
      expect { Holding.new }.to raise_error ArgumentError
    end
  end
  context 'when initialized with a service response argument' do
    context 'but the service response argument is not a ServiceResponse' do
      it 'should raise an ArgumentError' do
        expect { Holding.new("invalid") }.to raise_error ArgumentError
      end
    end
  end
end
