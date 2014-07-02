require 'rails_helper'
class HoldingRequest
  describe PickupLocations, vcr: {cassette_name: 'holding_requests/pickup_locations'} do
    let(:service_response) { build(:nyu_aleph_service_response) }
    let(:holding) { GetIt::Holding::NyuAleph.new(service_response)}
    let(:user) { build(:aleph_user) }
    let(:holding_request) { HoldingRequest.new(holding, user) }
    subject(:pickup_locations) { PickupLocations.new(holding_request) }
    it { should be_a Presenter }
    it { should be_a PickupLocations }
    describe '#each' do
      subject { pickup_locations.each }
      it { should be_an Enumerable }
      it 'should be an Enumerable of PickupLocations' do
        pickup_locations.each do |pickup_location|
          expect(pickup_location).to be_a Exlibris::Aleph::PickupLocation
        end
      end
    end
    describe '#size' do
      subject { pickup_locations.size }
      it { should be_an Integer }
      it { should eq 10 }
    end
    describe '#to_a' do
      subject { pickup_locations.to_a }
      it { should be_an Array }
    end
  end
end
