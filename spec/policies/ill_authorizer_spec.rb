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
  describe '#patron_statuses' do
    subject { authorizer.send(:patron_statuses) }
    let(:patron_statuses) { [{"name" => "Master's Student", "code" => "51"}] }
    before { allow(Figs).to receive_message_chain(:env, :ill_patron_statuses).and_return(patron_statuses) }
    context 'when patron statuses are a hash from a config' do
      it { should eql ["51"] }
    end
    context 'when patron statuses are an array from an environment variable' do
      let(:patron_statuses) { ["51"] }
      it { should eql ["51"] }
    end
    context 'when patron statuses are empty' do
      let(:patron_statuses) { nil }
      it { should be_empty }
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
