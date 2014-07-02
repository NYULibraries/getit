require 'rails_helper'
describe 'holding_requests/_new_available', vcr: {cassette_name: 'holding requests'} do
  let(:_service_response) { create(:on_shelf_nyu_aleph_service_response) }
  let(:_holding) { GetIt::Holding::NyuAleph.new(_service_response) }
  let(:_user) { build(:aleph_user) }
  let(:_holding_request) { HoldingRequest.new(_holding, _user) }
  subject { rendered }
  before do
    assign(:holding_request, _holding_request)
    render '/holding_requests/new_available'
  end
  it { should match /id="holding-request-available"/ }
  it { should match /name="type"/ }
  it { should match /value="available"/ }
  it { should match /id="holding-request-option-available-entire"/ }
  it { should match /for="entire_yes"/ }
  it { should match /id="entire_yes"/ }
  it { should match /Request this item to be delivered to the pickup location of your choice./ }
  it { should match /name="pickup_location"/ }
  it { should match /id="holding-request-option-available-scan"/ }
  it { should match /for="entire_no"/ }
  it { should match /id="entire_no"/ }
  it { should match /Request that a portion of the item be scanned and delivered electronically./ }
  it { should match /class="fair-use-disclaimer"/ }
  context "when the holding's sub library is not in NYU NY" do
    let(:_service_response) { create(:abu_dhabi_nyu_aleph_service_response) }
    it { should match /id="holding-request-available"/ }
    it { should match /name="type"/ }
    it { should match /value="available"/ }
    it { should_not match /id="holding-request-option-available-entire"/ }
    it { should_not match /id="holding-request-option-available-scan"/ }
    it { should_not match /Request that a portion of the item be scanned and delivered electronically./ }
    it { should match /Request this item. It will be held for you at the specified pickup location. Items are ready for pickup within 2 business days./ }
  end
end
