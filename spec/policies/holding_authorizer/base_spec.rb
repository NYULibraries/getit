# A holding authorizer takes a holding and an optional
# user and determines whether the holding/user combination
# is authorized for a given action.
# This is the base specification
require 'spec_helper'
module HoldingAuthorizer
  describe Base do
    let(:service_response) { build(:service_response) }
    let(:holding) { Holding.new(service_response) }
    let(:user) { build(:user) }
    subject(:base) { Base.new(holding, user) }
    it { should be_a Base }
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
      context 'and the holding argument is a Holding' do
        context 'and the user argument is missing' do
          it 'should not raise an error' do
            expect { Base.new(holding) }.not_to raise_error
          end
        end
        context 'and the user argument is present' do
          context 'but the user argument is not a User' do
            it 'should raise an ArgumentError' do
              expect { Base.new(holding, "invalid") }.to raise_error ArgumentError
            end
          end
        end
      end
    end
  end
end