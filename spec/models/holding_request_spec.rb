require 'rails_helper'
describe HoldingRequest, vcr: {cassette_name: 'holding requests'} do
  let(:service_response) { build(:nyu_aleph_service_response) }
  let(:holding) { GetIt::Holding::NyuAleph.new(service_response) }
  let(:user) { build(:aleph_user) }
  subject(:holding_request) { HoldingRequest.new(holding, user) }
  it { should be_a HoldingRequest }
  describe '#holding' do
    subject { holding_request.holding }
    it { should be_a GetIt::Holding::NyuAleph }
    it { should eq holding }
  end
  describe '#user' do
    subject { holding_request.user }
    it { should be_a User }
    it { should eq user }
  end
  describe '#circulation_policy' do
    subject { holding_request.circulation_policy }
    it { should be_an Exlibris::Aleph::Patron::Record::Item::CirculationPolicy }
  end
  describe '#create_hold' do
    let(:pickup_location) do
      Exlibris::Aleph::PickupLocation.new('BOBST', 'NYU Bobst')
    end
    let(:parameters) { {pickup_location: pickup_location} }
    subject { holding_request.create_hold(parameters) }
    it { should be_an Exlibris::Aleph::Patron::Record::Item::CreateHold }
    it { should_not be_error }
  end
  context 'when initialized without any arguments' do
    it 'should raise an ArgumentError' do
      expect { HoldingRequest.new }.to raise_error ArgumentError
    end
  end
  context 'when initialized with a holding argument' do
    context 'but the holding argument is not a Holding::Base' do
      it 'should raise an ArgumentError' do
        expect { HoldingRequest.new("invalid") }.to raise_error ArgumentError
      end
    end
    context 'but the holding argument is not a Holding::NyuAleph' do
      subject(:holding) { GetIt::Holding::PrimoSource.new(service_response) }
      it 'should raise an ArgumentError' do
        expect { HoldingRequest.new("invalid") }.to raise_error ArgumentError
      end
    end
    context 'and the holding argument is a Holding' do
      context 'but the user argument is missing' do
        it 'should raise an ArgumentError' do
          expect { HoldingRequest.new(holding) }.to raise_error ArgumentError
        end
      end
      context 'and the user argument is present' do
        context 'but the user argument is not a User' do
          it 'should raise an ArgumentError' do
            expect { HoldingRequest.new(holding, "invalid") }.to raise_error ArgumentError
          end
        end
      end
    end
  end
end
