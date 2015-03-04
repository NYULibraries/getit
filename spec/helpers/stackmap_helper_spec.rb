require "rails_helper"
describe EZBorrowHelper do
  let(:service_response) { build(:nyu_aleph_service_response) }
  let(:holding) { GetIt::HoldingManager.new(service_response).holding }
  describe '#stackmap_policy' do
    subject { helper.stackmap_policy(holding) }
    it { should be_a StackMapPolicy }
  end
  describe '#stackmap_presenter' do
    subject { helper.stackmap_presenter(holding) }
    it { should be_a StackMapPresenter }
  end
end
