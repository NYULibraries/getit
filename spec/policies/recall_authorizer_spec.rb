require 'rails_helper'
describe RecallAuthorizer do
  let(:user) { build(:aleph_user) }
  subject(:authorizer) { RecallAuthorizer.new(user) }
  it { should be_an RecallAuthorizer }
  describe '#user' do
    subject { authorizer.user }
    it { should eq user }
  end
  describe '#authorized?' do
    subject { authorizer.authorized? }
    context 'when the user does NOT have ILL privileges' do
      context 'but the user has EZborrow privileges' do
        context 'and the user is a New School user' do
          let(:user) { build(:ezborrow_ns_user) }
          it { should be true }
        end
        context 'and the user is NOT a New School user' do
          let(:user) { build(:ezborrow_user) }
          it { should be false }
        end
      end
      context 'and the user does NOT have EZborrow privileges' do
        let(:user) { build(:non_ill_user) }
        it { should be true }
      end
    end
    context 'when the user has ILL privileges' do
      let(:user) { build(:ill_user) }
      it { should be false }
    end
  end

end
