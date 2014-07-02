require 'rails_helper'
describe 'holding_requests/_new_processing', vcr: {cassette_name: 'holding requests'} do
  let(:_service_response) { create(:processing_nyu_aleph_service_response) }
  let(:_holding) { GetIt::Holding::NyuAleph.new(_service_response) }
  let(:_user) { build(:aleph_user) }
  let(:_holding_request) { HoldingRequest.new(_holding, _user) }
  subject { rendered }
  before do
    assign(:holding_request, _holding_request)
    render '/holding_requests/new_processing'
  end
  it { should match /id="holding-request-processing"/ }
  it { should match /name="type"/ }
  it { should match /value="processing"/ }
  it { should match /id="holding-request-option-processing"/ }
  it { should match /Request for this item to be held for you once processed./ }
  it { should match /Items are typically ready for pickup within 5 days./ }
  it { should match /name="pickup_location"/ }
end
