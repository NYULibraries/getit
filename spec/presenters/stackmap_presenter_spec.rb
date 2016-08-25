require 'rails_helper'
describe StackMapPresenter do
  let(:service_response) { build(:nyu_aleph_service_response) }
  let(:holding) { GetIt::HoldingManager.new(service_response).holding }
  subject(:presenter) { StackMapPresenter.new(holding) }
  it { should be_a StackMapPresenter }
  describe '#holding' do
    subject { presenter.holding }
    it { should eq holding }
  end
  describe '#library' do
    subject { presenter.library }
    context 'when the service response is "available" in the New School Main Collection' do
      let(:service_response) do
        build(:available_new_school_main_collection_service_response)
      end
      it { should eq 'TNS University Center Library' }
    end
    context 'when the holding is a journal in the "New School Main Collection"' do
      let(:service_response) do
        build(:new_school_main_collection_journal_service_response)
      end
      context 'when holding is from aleph' do
        it { should eq 'TNS University Center Library'}
      end
      context 'when holding is not from aleph' do
        before { allow(presenter).to receive(:from_aleph?).and_return(false) }
        it { should be_nil }
      end
    end
  end
  describe '#location' do
    subject { presenter.location }
    context 'when the service response is "available" in the New School Main Collection' do
      let(:service_response) do
        build(:available_new_school_main_collection_service_response)
      end
      context 'when holding is from aleph' do
        it { should eq 'Main Collection'}
      end
      context 'when holding is not from aleph' do
        before { allow(presenter).to receive(:from_aleph?).and_return(false) }
        it { should eq 'NYU Bobst Main Collection' }
      end
    end
    context 'when the holding is a journal in the "New School Main Collection"' do
      let(:service_response) do
        build(:new_school_main_collection_journal_service_response)
      end
      it { should eq 'Main Collection'}
    end
  end
  describe '#call_number' do
    subject { presenter.call_number }
    context 'when the service response is "available" in the New School Main Collection' do
      let(:service_response) do
        build(:available_new_school_main_collection_service_response)
      end
      it { should eq 'DS126 .M62 2002'}
    end
    context 'when the holding is a journal in the "New School Main Collection"' do
      let(:service_response) do
        build(:new_school_main_collection_journal_service_response)
      end
      it { should eq 'TS171.A1 R48'}
    end
  end
  describe '#prefix' do
    subject { presenter.prefix }
    it { should eq 'newschool' }
  end
  context 'when initialized with a holding argument' do
    context 'but the holding argument is not an NyuAleph Holding' do
      let(:holding) { :invalid }
      it 'should raise an ArgumentError' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end
end
