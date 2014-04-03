# A holding requestability authorizer takes a holding and an optional
# user and determines whether the holding/user combination
# is authorized for a given action.
# This is the base specification
require 'spec_helper'
module HoldingAuthorizer
  describe Requestability do
    let(:service_response) { build(:service_response) }
    let(:holding) { Holding.new(service_response) }
    let(:user) { build(:user) }
    subject(:requestability) do
      Requestability.new(holding, user)
    end
    it { should be_a Base }
    it { should be_a Requestability }
    describe '#requestable?' do
      subject { requestability.requestable? }
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
    end
    describe '#ill?' do
      subject { requestability.ill? }
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
    end
    context 'when initialized without any arguments' do
      it 'should raise an ArgumentError' do
        expect { Requestability.new }.to raise_error ArgumentError
      end
    end
    context 'when initialized with a holding argument' do
      context 'but the holding argument is not a Holding' do
        it 'should raise an ArgumentError' do
          expect { Requestability.new("invalid") }.to raise_error ArgumentError
        end
      end
      context 'and the holding argument is a Holding' do
        context 'and the user argument is missing' do
          it 'should raise an ArgumentError' do
            expect { Requestability.new(holding) }.to raise_error ArgumentError
          end
        end
        context 'and the user argument is present' do
          context 'but the user argument is not a User' do
            it 'should raise an ArgumentError' do
              expect { Requestability.new(holding, "invalid") }.to raise_error ArgumentError
            end
          end
        end
      end
    end
  end
end
