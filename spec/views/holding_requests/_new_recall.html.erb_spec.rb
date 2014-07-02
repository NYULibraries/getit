require 'rails_helper'
describe 'holding_requests/_new_recall', vcr: {cassette_name: 'holding requests'} do
  let(:_service_response) { create(:checked_out_nyu_aleph_service_response) }
  let(:_holding) { GetIt::Holding::NyuAleph.new(_service_response) }
  let(:_user) { build(:aleph_user) }
  let(:_holding_request) { HoldingRequest.new(_holding, _user) }
  subject { rendered }
  before do
    assign(:holding_request, _holding_request)
    render '/holding_requests/new_recall'
  end
  it { should match /id="holding-request-recall"/ }
  it { should match /name="type"/ }
  it { should match /value="recall"/ }
  it { should match /id="holding-request-option-recall"/ }
  it { should match /Recall this item from a fellow library user./ }
  it { should match /The item will be available within 2 weeks./ }
  it { should match /name="pickup_location"/ }
end
