# A holding request policy takes a holding and a user
# and determines whether the holding/user combination
# is authorized for a given action.
# This is the base specification
require 'spec_helper'
module Policies
  describe HoldingRequestAuthorizer do
    let(:service_response) { build(:service_response) }
    let(:holding) { Holding.new(service_response) }
    let(:user) { build(:aleph_user) }
    subject(:policy) do
      HoldingRequestAuthorizer.new(holding, user)
    end
    it { should be_a Base }
    it { should be_a HoldingRequestAuthorizer }
    describe '#requestable?' do
      subject { policy.requestable? }
      context 'when the holding is in an ILL state' do
        let(:service_response) { build(:ill_service_response) }
        context 'and the user is nil' do
          let(:user) { nil }
          it { should be_true }
        end
        context 'and the user is not nil' do
          let(:user) { build(:aleph_user) }
          it { should be_true }
        end
      end
      context 'when the holding is never requestable' do
        let(:service_response) { build(:never_requestable_service_response) }
        context 'and the user is nil' do
          let(:user) { nil }
          it { should be_false }
        end
        context 'and the user is not nil' do
          let(:user) { build(:aleph_user) }
          it { should be_false }
        end
      end
      context 'when the holding is always requestable' do
        let(:service_response) { build(:always_requestable_service_response) }
        context 'and the user is nil' do
          let(:user) { nil }
          it { should be_true }
        end
        context 'and the user is not nil' do
          let(:user) { build(:aleph_user) }
          context 'but the user does not have rights to request holdings in this sublibrary' do
            before { user.user_attributes[:aleph_permissions]['BOBST'][:hold_permission] = 'N' }
            context 'and the holding is not in an ILL state' do
              before { service_response.service_data[:status_code] = 'available' }
              it { should be_false }
            end
            context 'and the holding is in an ILL state' do
              it { should be_true }
            end
          end
          context 'and the user does have rights to request holdings in this sublibrary' do
            it { should be_true }
          end
        end
      end
      context 'when the holding is requestable depending on the user requesting' do
        let(:service_response) { build(:deferred_requestability_service_response) }
        context 'and the user is nil' do
          let(:user) { nil }
          it { should be_false }
        end
        context 'and the user is not nil' do
          let(:user) { build(:aleph_user) }
          context 'but the user does not have rights to request holdings in this sublibrary' do
            before { user.user_attributes[:aleph_permissions]['BOBST'][:hold_permission] = 'N' }
            it { should be_false }
          end
          context 'and the user does have rights to request holdings in this sublibrary' do
            it { should be_true }
          end
        end
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
          let(:user) { build(:aleph_user) }
          context 'but the user does not have rights to request holdings in this sublibrary' do
            before { user.user_attributes[:aleph_permissions]['BOBST'][:hold_permission] = 'N' }
            it { should be_false }
          end
          context 'and the user does have rights to request holdings in this sublibrary' do
            context 'but the user does not have rights to request holdings that are "available"' do
              before { user.user_attributes[:aleph_permissions]['BOBST'][:hold_on_shelf] = 'N' }
              it { should be_false }
            end
            context 'and the user has rights to request holdings that are "available"' do
              it { should be_true }
            end
          end
        end
      end
      context 'when the holding is in a non "available" state' do
        let(:service_response) { build(:ill_service_response) }
        it { should be_false }
      end
    end
    describe '#recallable?' do
      subject { policy.recallable? }
      context 'when the holding is in a "recallable" state' do
        let(:service_response) { build(:checked_out_service_response) }
        context 'and the user is nil' do
          let(:user) { nil }
          it { should be_true }
        end
        context 'and the user is not nil' do
          let(:user) { build(:aleph_user) }
          context 'but the user does not have rights to request holdings in this sublibrary' do
            before { user.user_attributes[:aleph_permissions]['BOBST'][:hold_permission] = 'N' }
            it { should be_false }
          end
          context 'and the user does have rights to request holdings in this sublibrary' do
            it { should be_true }
          end
        end
      end
      context 'when the holding is in a non "recallable" state' do
        let(:service_response) { build(:ill_service_response) }
        it { should be_false }
      end
    end
    describe '#offsite?' do
      subject { policy.offsite? }
      context 'when the holding is in an "offsite" state' do
        let(:service_response) { build(:offsite_service_response) }
        context 'and the user is nil' do
          let(:user) { nil }
          it { should be_true }
        end
        context 'and the user is not nil' do
          let(:user) { build(:aleph_user) }
          context 'but the user does not have rights to request holdings in this sublibrary' do
            before { user.user_attributes[:aleph_permissions]['BOBST'][:hold_permission] = 'N' }
            it { should be_false }
          end
          context 'and the user does have rights to request holdings in this sublibrary' do
            it { should be_true }
          end
        end
      end
      context 'when the holding is in a non "offsite" state' do
        let(:service_response) { build(:ill_service_response) }
        it { should be_false }
      end
    end
    describe '#processing?' do
      subject { policy.processing? }
      context 'when the holding is in a "processing" state' do
        let(:service_response) { build(:processing_service_response) }
        context 'and the user is nil' do
          let(:user) { nil }
          it { should be_true }
        end
        context 'and the user is not nil' do
          let(:user) { build(:aleph_user) }
          context 'but the user does not have rights to request holdings in this sublibrary' do
            before { user.user_attributes[:aleph_permissions]['BOBST'][:hold_permission] = 'N' }
            it { should be_false }
          end
          context 'and the user does have rights to request holdings in this sublibrary' do
            it { should be_true }
          end
        end
      end
      context 'when the holding is in a non "processing" state' do
        let(:service_response) { build(:ill_service_response) }
        it { should be_false }
      end
    end
    describe '#on_order?' do
      subject { policy.on_order? }
      context 'when the holding is in a "on order" state' do
        let(:service_response) { build(:on_order_service_response) }
        context 'and the user is nil' do
          let(:user) { nil }
          it { should be_true }
        end
        context 'and the user is not nil' do
          let(:user) { build(:aleph_user) }
          context 'but the user does not have rights to request holdings in this sublibrary' do
            before { user.user_attributes[:aleph_permissions]['BOBST'][:hold_permission] = 'N' }
            it { should be_false }
          end
          context 'and the user does have rights to request holdings in this sublibrary' do
            it { should be_true }
          end
        end
      end
      context 'when the holding is in a non "on order" state' do
        let(:service_response) { build(:ill_service_response) }
        it { should be_false }
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
          let(:user) { build(:aleph_user) }
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
          let(:user) { build(:aleph_user) }
          it { should be_false }
        end
      end
    end
    context 'when initialized without any arguments' do
      it 'should raise an ArgumentError' do
        expect { HoldingRequestAuthorizer.new }.to raise_error ArgumentError
      end
    end
    context 'when initialized with a holding argument' do
      context 'but the holding argument is not a Holding' do
        it 'should raise an ArgumentError' do
          expect { HoldingRequestAuthorizer.new("invalid") }.to raise_error ArgumentError
        end
      end
      context 'and the holding argument is a Holding' do
        context 'and the user argument is missing' do
          it 'should raise an ArgumentError' do
            expect { HoldingRequestAuthorizer.new(holding) }.to raise_error ArgumentError
          end
        end
        context 'and the user argument is present' do
          context 'but the user argument is not a User' do
            it 'should raise an ArgumentError' do
              expect { HoldingRequestAuthorizer.new(holding, "invalid") }.to raise_error ArgumentError
            end
          end
        end
      end
    end
  end
end
