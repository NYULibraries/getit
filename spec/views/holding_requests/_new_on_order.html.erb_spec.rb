require 'rails_helper'
describe 'holding_requests/_new_on_order', vcr: {cassette_name: 'holding requests'} do
  let(:_service_response) { create(:on_order_nyu_aleph_service_response) }
  let(:_holding) { GetIt::Holding::NyuAleph.new(_service_response) }
  let(:_user) { build(:aleph_user) }
  let(:_holding_request) { HoldingRequest.new(_holding, _user) }
  subject { rendered }
  before do
    assign(:holding_request, _holding_request)
    render '/holding_requests/new_on_order'
  end
  it { should match /id="holding-request-on_order"/ }
  it { should match /name="type"/ }
  it { should match /value="on_order"/ }
  it { should match /id="holding-request-option-on_order"/ }
  it { should match /Request for this item to be held for you once processed./ }
  it { should match /With open orders, the library cannot predict or guarantee the date of delivery./ }
  it { should match /If you have an urgent deadline, it is better to use Interlibrary Loan./ }
  it { should match /name="pickup_location"/ }
end
