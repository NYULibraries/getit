require 'rails_helper'
class HoldingRequest
  describe Title do
    let(:service_response) { build(:nyu_aleph_service_response) }
    let(:holding) { GetIt::Holding::NyuAleph.new(service_response)}
    let(:user) { build(:aleph_user) }
    let(:holding_request) { HoldingRequest.new(holding, user) }
    subject(:title) { Title.new(holding_request) }
    it { should be_a Presenter }
    it { should be_a Title }
    describe '#holding' do
      subject { title.holding }
      it { should be_a GetIt::Holding::NyuAleph }
    end
    describe '#value' do
      subject { title.value }
      it { should be_a String }
      context 'when the holding is in an "ILL" state' do
        let(:service_response) { build(:ill_nyu_aleph_service_response) }
        it { should eq '"Title" is currently out of circulation.' }
      end
      context 'when the holding is in an "available" state' do
        let(:service_response) { build(:available_nyu_aleph_service_response) }
        it { should eq '"Title" is available at NYU Bobst.' }
      end
      context 'when the holding is "offsite"' do
        let(:service_response) { build(:offsite_nyu_aleph_service_response) }
        it { should eq '"Title" is available from the NYU Bobst offsite storage facility.' }
      end
      context 'when the holding is "checked out"' do
        let(:service_response) { build(:checked_out_nyu_aleph_service_response) }
        it { should eq '"Title" is checked out.' }
      end
      context 'when the holding is "requested"' do
        let(:service_response) { build(:requested_nyu_aleph_service_response) }
        it { should eq '"Title" is requested.' }
      end
      context 'when the holding is "on order"' do
        let(:service_response) { build(:on_order_nyu_aleph_service_response) }
        it { should eq '"Title" is on order.' }
      end
      context 'when the holding is "billed as lost"' do
        let(:service_response) { build(:billed_as_lost_nyu_aleph_service_response) }
        it { should eq '"Title" is currently out of circulation.' }
      end
    end
    describe '#to_s' do
      subject { title.to_s }
      it { should be_a String }
      context 'when the holding is in an "ILL" state' do
        let(:service_response) { build(:ill_nyu_aleph_service_response) }
        it { should eq '"Title" is currently out of circulation.' }
      end
      context 'when the holding is in an "available" state' do
        let(:service_response) { build(:available_nyu_aleph_service_response) }
        it { should eq '"Title" is available at NYU Bobst.' }
      end
      context 'when the holding is "offsite"' do
        let(:service_response) { build(:offsite_nyu_aleph_service_response) }
        it { should eq '"Title" is available from the NYU Bobst offsite storage facility.' }
      end
      context 'when the holding is "checked out"' do
        let(:service_response) { build(:checked_out_nyu_aleph_service_response) }
        it { should eq '"Title" is checked out.' }
      end
      context 'when the holding is "requested"' do
        let(:service_response) { build(:requested_nyu_aleph_service_response) }
        it { should eq '"Title" is requested.' }
      end
      context 'when the holding is "on order"' do
        let(:service_response) { build(:on_order_nyu_aleph_service_response) }
        it { should eq '"Title" is on order.' }
      end
      context 'when the holding is "billed as lost"' do
        let(:service_response) { build(:billed_as_lost_nyu_aleph_service_response) }
        it { should eq '"Title" is currently out of circulation.' }
      end
    end
  end
end
