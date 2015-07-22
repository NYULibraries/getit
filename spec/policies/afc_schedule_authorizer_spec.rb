require 'rails_helper'
describe AFCScheduleAuthorizer do
  let(:user) { build(:afc_user) }
  subject(:authorizer) { AFCScheduleAuthorizer.new(user) }
  it { should be_an PatronStatusAuthorizer }
  it { should be_an AFCScheduleAuthorizer }
  describe '#user' do
    subject { authorizer.user }
    it { should eq user }
  end
  describe '#authorized_bor_statuses' do
    subject { authorizer.authorized_bor_statuses }
    it { should eq %w{03 05 10 12 20 30 32 50 52 53 54 61 62 70 80 89 90} }
  end
  describe '#authorized?' do
    subject { authorizer.authorized? }
    context 'when the user is authorized' do
      let(:user) { build(:afc_user) }
      it { should be true }
    end
    context 'when the user is not authorized' do
      let(:user) { build(:non_afc_user) }
      it { should be false }
    end
  end

  context 'when initialized with a user argument' do
    context 'but the user is not a User' do
      let(:user) { :invalid }
      it 'should raise an ArgumentError' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end
end
