require 'rails_helper'
describe EZBorrowAuthorizer do
  let(:user) { build(:aleph_user) }
  subject(:authorizer) { EZBorrowAuthorizer.new(user) }
  it { should be_an PatronStatusAuthorizer }
  it { should be_an EZBorrowAuthorizer }
  describe '#user' do
    subject { authorizer.user }
    it { should eq user }
  end
  describe '#authorized_bor_statuses' do
    subject { authorizer.authorized_bor_statuses }
    it { should eq %w{50 51 52 53 54 55 56 57 58 60 61 62 63 65 66 80 81 82 30 31 32 33 34 35 36 37 38 39 40 41} }
  end
  describe '#authorized?' do
    subject { authorizer.authorized? }
    context 'when the user is authorized' do
      let(:user) { build(:ezborrow_user) }
      it { should be true }
    end
    context 'when the user is not authorized' do
      let(:user) { build(:non_ezborrow_user) }
      it { should be false }
    end
  end
  describe '#ns_ezborrow?' do
    subject { authorizer.ns_ezborrow? }
    context 'when user is a New School E-ZBorrow user' do
      let(:user) { build(:ezborrow_ns_user) }
      it { should be true }
    end
    context 'when user is an NYU E-ZBorrow user' do
      let(:user) { build(:ezborrow_user) }
      it { should be false }
    end
  end
  describe '#nyu_ezborrow?' do
    subject { authorizer.nyu_ezborrow? }
    context 'when user is a New School E-ZBorrow user' do
      let(:user) { build(:ezborrow_ns_user) }
      it { should be false }
    end
    context 'when user is an NYU E-ZBorrow user' do
      let(:user) { build(:ezborrow_user) }
      it { should be true }
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
