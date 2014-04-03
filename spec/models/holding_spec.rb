require 'spec_helper'
describe Holding do
  let(:service_response) { create(:service_response) }
  subject(:holding) { Holding.new(service_response) }
  it { should be_a Holding }
  describe '#ill?' do
    subject { holding.ill? }
    context 'when it is an ILL service response' do
      let(:service_response) { build(:ill_service_response) }
      it { should be_true }
    end
    context 'when it is not an ILL service response' do
      let(:service_response) { build(:available_service_response) }
      it { should be_false }
    end
  end
  describe '#available?' do
    subject { holding.available? }
    context 'when it is an available service response' do
      let(:service_response) { build(:available_service_response) }
      it { should be_true }
    end
    context 'when it is not an available service response' do
      let(:service_response) { build(:ill_service_response) }
      it { should be_false }
    end
  end
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
