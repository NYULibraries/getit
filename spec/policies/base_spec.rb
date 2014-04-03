# A holding policy takes a holding determines
# whether the holding is authorized for a given action.
# This is the base specification
require 'spec_helper'
module Policies
  describe Base do
    let(:service_response) { build(:service_response) }
    let(:holding) { Holding.new(service_response) }
    subject(:policy) { Base.new(holding) }
    it { should be_a Base }
    describe '#holding' do
      subject { policy.holding }
      it { should be_a Holding }
      it { should eq holding }
    end
    context 'when initialized without any arguments' do
      it 'should raise an ArgumentError' do
        expect { Base.new }.to raise_error ArgumentError
      end
    end
    context 'when initialized with a holding argument' do
      context 'but the holding argument is not a Holding' do
        it 'should raise an ArgumentError' do
          expect { Base.new("invalid") }.to raise_error ArgumentError
        end
      end
    end
  end
end