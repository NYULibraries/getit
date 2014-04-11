require 'spec_helper'
describe AlephUser do
  let(:service_response) { build(:available_service_response) }
  let(:holding) { Holding.new(service_response) }
  let(:user) { build :aleph_user }
  subject(:aleph_user) { AlephUser.new(user) }
  describe '#bor_id' do
    subject { aleph_user.bor_id }
    it { should eq 'BOR_ID' }
  end
  describe '#verification' do
    subject { aleph_user.verification }
    it { should eq 'VERIFICATION' }
  end
  describe '#can_request?' do
    subject { aleph_user.can_request?(holding) }
    context 'when the permissions are already persisted' do
      context 'and the user has permissions' do
        let(:service_response) { build(:available_service_response) }
        it { should be_true }
      end
      context 'and the user does not have permissions' do
        let(:service_response) { build(:afc_recalled_service_response) }
        it { should be_false }
      end
    end
    context 'when the permissions are not already persisted', vcr: { cassette_name: "bobst_permissions" } do
      before { user.user_attributes[:aleph_permissions] = nil }
      it { should be_true }
    end
    context 'when the verification is wrong', vcr: { cassette_name: "error_in_verification" } do
      before { user.user_attributes[:aleph_permissions] = nil }
      it { should be_false }
    end
    context 'when the holding argument is not a Holding' do
      let(:holding) { "invalid" }
      it 'should raise an ArgumentError' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end
  describe '#can_request_available?' do
    subject { aleph_user.can_request_available?(holding) }
    context 'when the permissions are already persisted' do
      context 'and the user has permissions' do
        let(:service_response) { build(:available_service_response) }
        it { should be_true }
      end
      context 'and the user does not have permissions' do
        let(:service_response) { build(:afc_recalled_service_response) }
        it { should be_false }
      end
    end
    context 'when the permissions are not already persisted', vcr: { cassette_name: "bobst_permissions" } do
      before { user.user_attributes[:aleph_permissions] = nil }
      it { should be_true }
    end
    context 'when the verification is wrong', vcr: { cassette_name: "error_in_verification" } do
      before { user.user_attributes[:aleph_permissions] = nil }
      it { should be_false }
    end
    context 'when the holding argument is not a Holding' do
      let(:holding) { "invalid" }
      it 'should raise an ArgumentError' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end
  describe '#can_request_ill?' do
    subject { aleph_user.can_request_ill?(holding) }
    context 'when the permissions are already persisted' do
      context 'and the user has permissions' do
        let(:service_response) { build(:available_service_response) }
        it { should be_true }
      end
      context 'and the user does not have permissions' do
        let(:service_response) { build(:afc_recalled_service_response) }
        it { should be_false }
      end
    end
    context 'when the permissions are not already persisted', vcr: { cassette_name: "bobst_permissions" } do
      before { user.user_attributes[:aleph_permissions] = nil }
      it { should be_true }
    end
    context 'when the verification is wrong', vcr: { cassette_name: "error_in_verification" } do
      before { user.user_attributes[:aleph_permissions] = nil }
      it { should be_false }
    end
    context 'when the holding argument is not a Holding' do
      let(:holding) { "invalid" }
      it 'should raise an ArgumentError' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end
  context 'when initialized without any arguments' do
    it 'should raise an ArgumentError' do
      expect { AlephUser.new }.to raise_error ArgumentError
    end
  end
  context 'when initialized with a user argument' do
    context 'but the user argument is not a User' do
      let(:user) { "invalid" }
      it 'should raise an ArgumentError' do
        expect { subject }.to raise_error ArgumentError
      end
    end
    context 'and the user argument is a User' do
      context 'but the user attributes are not a Hash' do
        let(:user) { build :user, user_attributes: nil }
        it 'should raise an ArgumentError' do
          expect { subject }.to raise_error ArgumentError
        end
      end
    end
  end
end
