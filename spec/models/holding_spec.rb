require 'spec_helper'
describe Holding do
  let(:service_response) { create(:service_response) }
  subject(:holding) { Holding.new(service_response) }
  it { should be_a Holding }
  describe '#ill?' do
    subject { holding.ill? }
    context 'when the service response has an processing status' do
      let(:service_response) { build(:processing_service_response) }
      it { should be_true }
    end
    context 'when the service response has an ILL status' do
      let(:service_response) { build(:ill_service_response) }
      it { should be_true }
    end
    context 'when the service response has a checked out status' do
      let(:service_response) { build(:checked_out_service_response) }
      it { should be_true }
    end
    context 'when the service response has a requested status' do
      let(:service_response) { build(:requested_service_response) }
      it { should be_true }
    end
    context 'when the service response has an on order status' do
      let(:service_response) { build(:on_order_service_response) }
      it { should be_true }
    end
    context 'when the service response has a billed as lost status' do
      let(:service_response) { build(:billed_as_lost_service_response) }
      it { should be_true }
    end
    context 'when the service response has an available status' do
      let(:service_response) { build(:available_service_response) }
      it { should be_false }
    end
    context 'when the service response has an offsite status' do
      let(:service_response) { build(:offsite_service_response) }
      it { should be_false }
    end
  end
  describe '#available?' do
    subject { holding.available? }
    context 'when the service response has an processing status' do
      let(:service_response) { build(:processing_service_response) }
      it { should be_false }
    end
    context 'when the service response has an ILL status' do
      let(:service_response) { build(:ill_service_response) }
      it { should be_false }
    end
    context 'when the service response has a checked out status' do
      let(:service_response) { build(:checked_out_service_response) }
      it { should be_false }
    end
    context 'when the service response has a requested status' do
      let(:service_response) { build(:requested_service_response) }
      it { should be_false }
    end
    context 'when the service response has an on order status' do
      let(:service_response) { build(:on_order_service_response) }
      it { should be_false }
    end
    context 'when the service response has a billed as lost status' do
      let(:service_response) { build(:billed_as_lost_service_response) }
      it { should be_false }
    end
    context 'when the service response has an available status' do
      let(:service_response) { build(:available_service_response) }
      it { should be_true }
    end
    context 'when the service response has an offsite status' do
      let(:service_response) { build(:offsite_service_response) }
      it { should be_false }
    end
  end
  describe '#checked_out?' do
    subject { holding.checked_out? }
    context 'when the service response has an processing status' do
      let(:service_response) { build(:processing_service_response) }
      it { should be_false }
    end
    context 'when the service response has an ILL status' do
      let(:service_response) { build(:ill_service_response) }
      it { should be_false }
    end
    context 'when the service response has a checked out status' do
      let(:service_response) { build(:checked_out_service_response) }
      it { should be_true }
    end
    context 'when the service response hasan requested status' do
      let(:service_response) { build(:requested_service_response) }
      it { should be_false }
    end
    context 'when the service response has an on order status' do
      let(:service_response) { build(:on_order_service_response) }
      it { should be_false }
    end
    context 'when the service response has a billed as lost status' do
      let(:service_response) { build(:billed_as_lost_service_response) }
      it { should be_false }
    end
    context 'when the service response has an available status' do
      let(:service_response) { build(:available_service_response) }
      it { should be_false }
    end
    context 'when the service response has an offsite status' do
      let(:service_response) { build(:offsite_service_response) }
      it { should be_false }
    end
  end
  describe '#offsite?' do
    subject { holding.offsite? }
    context 'when the service response has an processing status' do
      let(:service_response) { build(:processing_service_response) }
      it { should be_false }
    end
    context 'when the service response has an ILL status' do
      let(:service_response) { build(:ill_service_response) }
      it { should be_false }
    end
    context 'when the service response has a checked out status' do
      let(:service_response) { build(:checked_out_service_response) }
      it { should be_false }
    end
    context 'when the service response hasan requested status' do
      let(:service_response) { build(:requested_service_response) }
      it { should be_false }
    end
    context 'when the service response has an on order status' do
      let(:service_response) { build(:on_order_service_response) }
      it { should be_false }
    end
    context 'when the service response has a billed as lost status' do
      let(:service_response) { build(:billed_as_lost_service_response) }
      it { should be_false }
    end
    context 'when the service response has an available status' do
      let(:service_response) { build(:available_service_response) }
      it { should be_false }
    end
    context 'when the service response has an offsite status' do
      let(:service_response) { build(:offsite_service_response) }
      it { should be_true }
    end
  end
  describe '#requested?' do
    subject { holding.requested? }
    context 'when the service response has an processing status' do
      let(:service_response) { build(:processing_service_response) }
      it { should be_false }
    end
    context 'when the service response has an ILL status' do
      let(:service_response) { build(:ill_service_response) }
      it { should be_false }
    end
    context 'when the service response has a checked out status' do
      let(:service_response) { build(:checked_out_service_response) }
      it { should be_false }
    end
    context 'when the service response hasan requested status' do
      let(:service_response) { build(:requested_service_response) }
      it { should be_true }
    end
    context 'when the service response has an on order status' do
      let(:service_response) { build(:on_order_service_response) }
      it { should be_false }
    end
    context 'when the service response has a billed as lost status' do
      let(:service_response) { build(:billed_as_lost_service_response) }
      it { should be_false }
    end
    context 'when the service response has an available status' do
      let(:service_response) { build(:available_service_response) }
      it { should be_false }
    end
    context 'when the service response has an offsite status' do
      let(:service_response) { build(:offsite_service_response) }
      it { should be_false }
    end
  end
  describe '#recallable?' do
    subject { holding.recallable? }
    context 'when the service response has an processing status' do
      let(:service_response) { build(:processing_service_response) }
      it { should be_false }
    end
    context 'when the service response has an ILL status' do
      let(:service_response) { build(:ill_service_response) }
      it { should be_false }
    end
    context 'when the service response has a checked out status' do
      let(:service_response) { build(:checked_out_service_response) }
      it { should be_true }
    end
    context 'when the service response hasan requested status' do
      let(:service_response) { build(:requested_service_response) }
      it { should be_true }
    end
    context 'when the service response has an on order status' do
      let(:service_response) { build(:on_order_service_response) }
      it { should be_false }
    end
    context 'when the service response has a billed as lost status' do
      let(:service_response) { build(:billed_as_lost_service_response) }
      it { should be_false }
    end
    context 'when the service response has an available status' do
      let(:service_response) { build(:available_service_response) }
      it { should be_false }
    end
    context 'when the service response has an offsite status' do
      let(:service_response) { build(:offsite_service_response) }
      it { should be_false }
    end
  end
  describe '#processing?' do
    subject { holding.processing? }
    context 'when the service response has an processing status' do
      let(:service_response) { build(:processing_service_response) }
      it { should be_true }
    end
    context 'when the service response has an ILL status' do
      let(:service_response) { build(:ill_service_response) }
      it { should be_false }
    end
    context 'when the service response has a checked out status' do
      let(:service_response) { build(:checked_out_service_response) }
      it { should be_false }
    end
    context 'when the service response hasan requested status' do
      let(:service_response) { build(:requested_service_response) }
      it { should be_false }
    end
    context 'when the service response has an on order status' do
      let(:service_response) { build(:on_order_service_response) }
      it { should be_false }
    end
    context 'when the service response has a billed as lost status' do
      let(:service_response) { build(:billed_as_lost_service_response) }
      it { should be_false }
    end
    context 'when the service response has an available status' do
      let(:service_response) { build(:available_service_response) }
      it { should be_false }
    end
    context 'when the service response has an offsite status' do
      let(:service_response) { build(:offsite_service_response) }
      it { should be_false }
    end
  end
  describe '#in_processing?' do
    subject { holding.in_processing? }
    context 'when the service response has an processing status' do
      let(:service_response) { build(:processing_service_response) }
      it { should be_true }
    end
    context 'when the service response has an ILL status' do
      let(:service_response) { build(:ill_service_response) }
      it { should be_false }
    end
    context 'when the service response has a checked out status' do
      let(:service_response) { build(:checked_out_service_response) }
      it { should be_false }
    end
    context 'when the service response hasan requested status' do
      let(:service_response) { build(:requested_service_response) }
      it { should be_false }
    end
    context 'when the service response has an on order status' do
      let(:service_response) { build(:on_order_service_response) }
      it { should be_false }
    end
    context 'when the service response has a billed as lost status' do
      let(:service_response) { build(:billed_as_lost_service_response) }
      it { should be_false }
    end
    context 'when the service response has an available status' do
      let(:service_response) { build(:available_service_response) }
      it { should be_false }
    end
    context 'when the service response has an offsite status' do
      let(:service_response) { build(:offsite_service_response) }
      it { should be_false }
    end
  end
  context 'when initialized without any arguments' do
    it 'should raise an ArgumentError' do
      expect { Holding.new }.to raise_error ArgumentError
    end
  end
  context 'when initialized with a service response argument' do
    context 'but the service response argument is not a ServiceResponse' do
      it 'should raise an ArgumentError' do
        expect { Holding.new("invalid") }.to raise_error ArgumentError
      end
    end
  end
end
