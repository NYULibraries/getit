require 'rails_helper'
describe 'holding_requests/_new_ill', vcr: {cassette_name: 'holding requests'} do
  let(:_service_response) { create(:billed_as_lost_nyu_aleph_service_response) }
  let(:_holding) { GetIt::Holding::NyuAleph.new(_service_response) }
  let(:_user) { build(:aleph_user) }
  let(:_holding_request) { HoldingRequest.new(_holding, _user) }
  subject { rendered }
  before do
    assign(:holding_request, _holding_request)
    render '/holding_requests/new_ill'
  end
  it { should match /\/holding_requests\/#{_service_response.id}\/ill\/#{_holding.sub_library.code}/ }
  it { should match /id="holding-request-option-ill"/ }
  it { should match /Request a loan of this item via ILL./ }
  it { should match /Most requests arrive within two weeks./ }
  it { should match /Due dates and renewals are determined by the lending library./ }
  it { should match /Article\/chapter requests are typically delivered electronically in 3-5 days./ }
end
