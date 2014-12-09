require 'rails_helper'
describe 'holding_requests/_new_ezborrow', vcr: {cassette_name: 'holding requests'} do
  let(:_service_response) { create(:checked_out_nyu_aleph_service_response) }
  let(:_holding) { GetIt::Holding::NyuAleph.new(_service_response) }
  let(:_user) { build(:aleph_user) }
  let(:_holding_request) { HoldingRequest.new(_holding, _user) }
  subject { rendered }
  before do
    assign(:holding_request, _holding_request)
    render '/holding_requests/new_ezborrow'
  end
  it { should match /\/holding_requests\/#{_service_response.id}\/ezborrow\/#{_holding.sub_library.code}/ }
  it { should match /id="holding-request-option-ezborrow"/ }
  it { should match /Search E-ZBorrow for this item./ }
  it { should match /If available to request, the item should arrive in 3-5 days for 12 week loan./ }
end
