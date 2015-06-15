require 'rails_helper'
describe PatronStatusAuthorizer do
  let(:user) { build(:aleph_user) }
  subject(:authorizer) { PatronStatusAuthorizer.new(user) }
  it { should be_an PatronStatusAuthorizer }
  describe '#user' do
    subject { authorizer.user }
    it { should eq user }
  end
  describe '#authorized_bor_statuses' do
    subject { authorizer.authorized_bor_statuses }
    it { should be_nil }
  end
  describe '#authorized?' do
    subject { authorizer.authorized? }
    context "when implementing in the abstract class" do
      it "should raise an ArgumentError" do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end
  describe "#aleph_patron" do
    subject { authorizer.send(:aleph_patron) }
    it { should be_a GetIt::AlephPatron }
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
