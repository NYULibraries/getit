require 'rails_helper'
describe 'holding_requests/show' do
  let(:pickup_location) do
    Exlibris::Aleph::PickupLocation.new('BOBST', 'NYU Bobst')
  end
  let(:scan) { false }
  subject { rendered }
  before do
    allow(view).to receive(:scan?).and_return(scan)
    allow(view).to receive(:pickup_location).and_return(pickup_location)
    render template: '/holding_requests/show'
  end
  it { should match /<div class="text-success">/ }
  it { should match /Your request has been processed. You will be notified when this item is available to pick up at #{pickup_location.display}./ }
  context 'when it is a scan' do
    let(:scan) { true }
    it { should match /<div class="text-success">/ }
    it { should_not match /Your request has been processed. You will be notified when this item is available to pick up at #{pickup_location.display}./ }
    it { should match /Your scan request has been processed. You will receive an email when the item is available./ }
  end
end
