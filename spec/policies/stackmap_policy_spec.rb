require 'rails_helper'
describe StackMapPolicy do
  let(:service_response) { build(:nyu_aleph_service_response) }
  let(:holding) { GetIt::Holding::NyuAleph.new(service_response) }
  subject(:stackmap_policy) { StackMapPolicy.new(holding) }
  describe '#holding' do
    subject { stackmap_policy.holding }
    it { should eq holding }
  end

  context 'when initialized with a holding argument' do
    context 'but the holding argument is not a Holding' do
      let(:holding) { :invalid }
      it 'should raise an ArgumentError' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end
end
