require 'rails_helper'
describe 'holding_requests/_new_scan', vcr: {cassette_name: 'holding requests'} do
  let(:_service_response) { create(:isaw_nyu_aleph_service_response) }
  let(:_holding) { GetIt::Holding::NyuAleph.new(_service_response) }
  let(:_user) { build(:aleph_user) }
  let(:_holding_request) { HoldingRequest.new(_holding, _user) }
  subject { rendered }
  before do
    assign(:holding_request, _holding_request)
    render '/holding_requests/new_scan'
  end
  it { should match /id="holding-request-scan"/ }
  it { should match /for="entire_no"/ }
  it { should match /id="entire_no"/ }
  it { should match /Request that a portion of the item be scanned and delivered electronically./ }
  it { should match /class="fair-use-disclaimer"/ }
end
