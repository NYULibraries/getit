require 'rails_helper'
describe EZBorrowAuthorizer do
  describe EZBorrowAuthorizer::AUTHORIZED_BOR_STATUSES do
    subject { EZBorrowAuthorizer::AUTHORIZED_BOR_STATUSES }
    it do
      should eq %w{20 21 22 23 50 51 52 53 54 55 56 57 58 60 61 62 63 65 66 80 81 82}
    end
  end

  let(:user) { build(:aleph_user) }
  subject(:authorizer) { EZBorrowAuthorizer.new(user) }
  it { should be_an EZBorrowAuthorizer }
  describe '#user' do
    subject { authorizer.user }
    it { should eq user }
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

  context 'when initialized with a user argument' do
    context 'but the user is not a User' do
      let(:user) { :invalid }
      it 'should raise an ArgumentError' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end
end
