require 'rails_helper'
describe StackMapPolicy do
  let(:service_response) { build(:nyu_aleph_service_response) }
  let(:holding) { GetIt::HoldingManager.new(service_response).holding }
  subject(:stackmap_policy) { StackMapPolicy.new(holding) }
  describe '#holding' do
    subject { stackmap_policy.holding }
    it { should eq holding }
  end
  describe '#mappable?' do
    subject { stackmap_policy.mappable? }
    context 'when the holding is a book' do
      context 'and it is in the "New School Main Collection"' do
        context 'and it is "available"' do
          let(:service_response) do
            build(:available_new_school_main_collection_service_response)
          end
          it { should be true }
        end
        context 'and it is "checked out"' do
          let(:service_response) do
            build(:checked_out_new_school_main_collection_service_response)
          end
          it { should be false }
        end
        context 'and it is "offsite"' do
          let(:service_response) do
            build(:offsite_new_school_main_collection_service_response)
          end
          it { should be false }
        end
      end
      context 'and it is in the "New School Oversize Collection"' do
        context 'and it is "available"' do
          let(:service_response) do
            build(:available_new_school_oversize_collection_service_response)
          end
          it { should be true }
        end
        context 'and it is "checked out"' do
          let(:service_response) do
            build(:checked_out_new_school_oversize_collection_service_response)
          end
          it { should be false }
        end
        context 'and it is "offsite"' do
          let(:service_response) do
            build(:offsite_new_school_oversize_collection_service_response)
          end
          it { should be false }
        end
      end
      context "but it is not in the New School's Main or Oversize Collections" do
        let(:service_response) { build(:nyu_aleph_service_response) }
        it { should be false }
      end
    end
    context 'when the holding is a journal' do
      context 'and it is in the "New School Main Collection"' do
        let(:service_response) do
          build(:new_school_main_collection_journal_service_response)
        end
        it { should be true }
      end
      context 'and it is in the "New School Oversize Collection"' do
        let(:service_response) do
          build(:new_school_oversize_collection_journal_service_response)
        end
        it { should be true }
      end
      context "but it is not in the New School's Main or Oversize Collections" do
        let(:service_response) { build(:primo_service_response) }
        it { should be false }
      end
    end
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
