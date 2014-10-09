require 'rails_helper'
describe 'holding_requests/new', vcr: {cassette_name: 'holding requests'} do
  let(:_service_response) { create(:nyu_aleph_service_response) }
  let(:_holding) { GetIt::Holding::NyuAleph.new(_service_response) }
  let(:_user) { build(:aleph_user) }
  let(:_holding_request) { HoldingRequest.new(_holding, _user) }
  let(:_authorizer) { HoldingRequest::Authorizer.new(_holding_request) }
  subject { rendered }
  before do
    assign(:holding_request, _holding_request)
    assign(:authorizer, _authorizer)
    render template: '/holding_requests/new'
  end
  it { should match /class="holding-request"/ }
  it { should match /<h2>&quot;Title&quot; is checked out.<\/h2>/ }
  it { should match /class="holding-request-options"/ }
  it { should match /You will be notified by email when your item is ready or en route./ }
  it { should match /class="delivery-help"/ }
  it { should match /Not sure which option to choose?/ }
  context 'when the holding is on the shelf' do
    let(:_service_response) { create(:on_shelf_nyu_aleph_service_response) }
    it { should match /class="holding-request-options"/ }
    it { should match /<h2>&quot;Title&quot; is available at NYU Bobst.<\/h2>/ }
    it { should match /id="holding-request-option-available-entire"/ }
    it { should match /id="holding-request-option-available-scan"/ }
    it { should_not match /id="holding-request-option-recall"/ }
    it { should_not match /id="holding-request-option-offsite-entire"/ }
    it { should_not match /id="holding-request-option-offsite-scan"/ }
    it { should_not match /id="holding-request-option-processing"/ }
    it { should_not match /id="holding-request-option-on_order"/ }
    it { should_not match /id="holding-request-option-ill"/ }
    it { should_not match /id="holding-request-option-ezborrow"/ }
  end
  context 'when the holding is checked out' do
    let(:_service_response) { create(:checked_out_nyu_aleph_service_response) }
    it { should match /class="holding-request-options"/ }
    it { should match /<h2>&quot;Title&quot; is checked out.<\/h2>/ }
    it { should_not match /id="holding-request-option-available-entire"/ }
    it { should_not match /id="holding-request-option-available-scan"/ }
    it { should match /id="holding-request-option-recall"/ }
    it { should_not match /id="holding-request-option-offsite-entire"/ }
    it { should_not match /id="holding-request-option-offsite-scan"/ }
    it { should_not match /id="holding-request-option-processing"/ }
    it { should_not match /id="holding-request-option-on_order"/ }
    it { should match /id="holding-request-option-ill"/ }
    context 'and the user has permissions to request items from E-ZBorrow' do
      let(:_user) { build(:ezborrow_user) }
      it { should match /id="holding-request-option-ezborrow"/ }
    end
    context 'and the user does not have permissions to request items from E-ZBorrow' do
      let(:_user) { build(:non_ezborrow_user) }
      it { should_not match /id="holding-request-option-ezborrow"/ }
    end
  end
  context 'when the holding is offsite' do
    let(:_service_response) { create(:offsite_nyu_aleph_service_response) }
    it { should match /class="holding-request-options"/ }
    it { should match /<h2>&quot;Title&quot; is available from the NYU Bobst offsite storage facility.<\/h2>/ }
    it { should_not match /id="holding-request-option-available-entire"/ }
    it { should_not match /id="holding-request-option-available-scan"/ }
    it { should_not match /id="holding-request-option-recall"/ }
    it { should match /id="holding-request-option-offsite-entire"/ }
    it { should match /id="holding-request-option-offsite-scan"/ }
    it { should_not match /id="holding-request-option-processing"/ }
    it { should_not match /id="holding-request-option-on_order"/ }
    it { should_not match /id="holding-request-option-ill"/ }
    it { should_not match /id="holding-request-option-ezborrow"/ }
  end
  context 'when the holding is currently being processed' do
    let(:_service_response) { create(:processing_nyu_aleph_service_response) }
    it { should match /class="holding-request-options"/ }
    it { should match /<h2>&quot;Title&quot; is currently being processed by library staff.<\/h2>/ }
    it { should_not match /id="holding-request-option-available-entire"/ }
    it { should_not match /id="holding-request-option-available-scan"/ }
    it { should_not match /id="holding-request-option-recall"/ }
    it { should_not match /id="holding-request-option-offsite-entire"/ }
    it { should_not match /id="holding-request-option-offsite-scan"/ }
    it { should match /id="holding-request-option-processing"/ }
    it { should_not match /id="holding-request-option-on_order"/ }
    it { should match /id="holding-request-option-ill"/ }
    context 'and the user has permissions to request items from E-ZBorrow' do
      let(:_user) { build(:ezborrow_user) }
      it { should match /id="holding-request-option-ezborrow"/ }
    end
    context 'and the user does not have permissions to request items from E-ZBorrow' do
      let(:_user) { build(:non_ezborrow_user) }
      it { should_not match /id="holding-request-option-ezborrow"/ }
    end
  end
  context 'when the holding is on order' do
    let(:_service_response) { create(:on_order_nyu_aleph_service_response) }
    it { should match /class="holding-request-options"/ }
    it { should match /<h2>&quot;Title&quot; is on order.<\/h2>/ }
    it { should_not match /id="holding-request-option-available-entire"/ }
    it { should_not match /id="holding-request-option-available-scan"/ }
    it { should_not match /id="holding-request-option-recall"/ }
    it { should_not match /id="holding-request-option-offsite-entire"/ }
    it { should_not match /id="holding-request-option-offsite-scan"/ }
    it { should_not match /id="holding-request-option-processing"/ }
    it { should match /id="holding-request-option-on_order"/ }
    it { should match /id="holding-request-option-ill"/ }
    context 'and the user has permissions to request items from E-ZBorrow' do
      let(:_user) { build(:ezborrow_user) }
      it { should match /id="holding-request-option-ezborrow"/ }
    end
    context 'and the user does not have permissions to request items from E-ZBorrow' do
      let(:_user) { build(:non_ezborrow_user) }
      it { should_not match /id="holding-request-option-ezborrow"/ }
    end
  end
  context 'when the holding is billed as lost' do
    let(:_service_response) { create(:billed_as_lost_nyu_aleph_service_response) }
    it { should match /class="holding-request-options"/ }
    it { should match /<h2>&quot;Title&quot; is currently out of circulation.<\/h2>/ }
    it { should_not match /id="holding-request-option-available-entire"/ }
    it { should_not match /id="holding-request-option-available-scan"/ }
    it { should_not match /id="holding-request-option-recall"/ }
    it { should_not match /id="holding-request-option-offsite-entire"/ }
    it { should_not match /id="holding-request-option-offsite-scan"/ }
    it { should_not match /id="holding-request-option-processing"/ }
    it { should_not match /id="holding-request-option-on_order"/ }
    it { should match /id="holding-request-option-ill"/ }
    context 'and the user has permissions to request items from E-ZBorrow' do
      let(:_user) { build(:ezborrow_user) }
      it { should match /id="holding-request-option-ezborrow"/ }
    end
    context 'and the user does not have permissions to request items from E-ZBorrow' do
      let(:_user) { build(:non_ezborrow_user) }
      it { should_not match /id="holding-request-option-ezborrow"/ }
    end
  end
  context 'when the authorizer is nil' do
    let(:_authorizer) { nil }
    it { should match /class="holding-request"/ }
    it { should_not match /<h2>"Title" is checked out.<\/h2>/ }
    context 'and the holding request is nil' do
      let(:_holding_request) { nil }
      it { should match /class="holding-request"/ }
      it { should_not match /<h2>"Title" is checked out.<\/h2>/ }
    end
  end
end
