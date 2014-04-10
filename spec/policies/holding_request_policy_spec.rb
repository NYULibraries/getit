# A holding request policy takes a holding and a user
# and determines whether the holding/user combination
# is authorized for a given action.
# This is the base specification
require 'spec_helper'
module Policies
  describe HoldingRequestPolicy do
    let(:service_response) { build(:service_response) }
    let(:holding) { Holding.new(service_response) }
    let(:user) { build(:user) }
    subject(:policy) do
      HoldingRequestPolicy.new(holding, user)
    end
    it { should be_a Base }
    it { should be_a HoldingRequestPolicy }
    describe '#requestable?' do
      subject { policy.requestable? }
      context 'when the holding is in an ILL state' do
        let(:service_response) { build(:ill_service_response) }
        context 'and the user is nil' do
          let(:user) { nil }
          it { should be_true }
        end
        context 'and the user is not nil' do
          let(:user) { build(:user) }
          it { should be_true }
        end
      end
      context 'when the holding is in other states' do
        it 'should respond appropriately'
      end
    end
    describe '#available?' do
      subject { policy.available? }
      context 'when the holding is in an "available" state' do
        let(:service_response) { build(:available_service_response) }
        context 'and the user is nil' do
          let(:user) { nil }
          it { should be_false }
        end
        context 'and the user is not nil' do
          context 'but the user does not have rights to request holdings in this sublibrary' do
            let(:user) { build(:user) }
            it { should be_false }
          end
          context 'and the user does have rights to request holdings in this sublibrary' do
            context 'but the user does not have rights to request holdings that are "available"' do
              let(:user) { build(:user) }
              it { should be_false }
            end
            context 'and the user has rights to request holdings that are "available"' do
              let(:user) { build(:user) }
              it 'should be true'
              # it { should be_true }
            end
          end
        end
      end
      context 'when the holding is in non "available" states' do
        it 'should be false'
        # it { should be_false }
      end
    end
    describe '#ill?' do
      subject { policy.ill? }
      context 'when the holding is in an ILL state' do
        let(:service_response) { build(:ill_service_response) }
        context 'and the user is nil' do
          let(:user) { nil }
          it { should be_true }
        end
        context 'and the user is not nil' do
          let(:user) { build(:user) }
          it { should be_true }
        end
      end
      context 'when the holding is in an available state' do
        let(:service_response) { build(:available_service_response) }
        context 'and the user is nil' do
          let(:user) { nil }
          it { should be_false }
        end
        context 'and the user is not nil' do
          let(:user) { build(:user) }
          it { should be_false }
        end
      end
      context 'when the holding is in other states' do
        it 'should respond appropriately'
      end
    end
    context 'when initialized without any arguments' do
      it 'should raise an ArgumentError' do
        expect { HoldingRequestPolicy.new }.to raise_error ArgumentError
      end
    end
    context 'when initialized with a holding argument' do
      context 'but the holding argument is not a Holding' do
        it 'should raise an ArgumentError' do
          expect { HoldingRequestPolicy.new("invalid") }.to raise_error ArgumentError
        end
      end
      context 'and the holding argument is a Holding' do
        context 'and the user argument is missing' do
          it 'should raise an ArgumentError' do
            expect { HoldingRequestPolicy.new(holding) }.to raise_error ArgumentError
          end
        end
        context 'and the user argument is present' do
          context 'but the user argument is not a User' do
            it 'should raise an ArgumentError' do
              expect { HoldingRequestPolicy.new(holding, "invalid") }.to raise_error ArgumentError
            end
          end
        end
      end
    end
  end
end
