require 'rails_helper'
describe ILLAuthorizer do
  let(:user) { build(:aleph_user) }
  subject(:authorizer) { ILLAuthorizer.new(user) }
  it { should be_an PatronStatusAuthorizer }
  it { should be_an ILLAuthorizer }
  describe '#user' do
    subject { authorizer.user }
    it { should eq user }
  end
  describe '#authorized_bor_statuses' do
    subject { authorizer.authorized_bor_statuses }
    it { should be_instance_of Array }
    it { should include "51" }
  end
  describe '#authorized?' do
    subject { authorizer.authorized? }
    context 'when the user is authorized' do
      let(:user) { build(:ill_user) }
      it { should be true }
    end
    context 'when the user is not authorized' do
      let(:user) { build(:non_ill_user) }
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
