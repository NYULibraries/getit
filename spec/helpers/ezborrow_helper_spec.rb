require "rails_helper"
describe EZBorrowHelper do
  describe '#ezborrowable?' do
    before { allow(helper).to receive(:current_user).and_return(user) }
    subject { helper.can_ezborrow? }
    context 'when there is a current user' do
      context 'and the user has permission to request an itme from E-ZBorrow' do
        let(:user) { build :ezborrow_user }
      end
      context "but the user doesn't have permission to request an itme from E-ZBorrow" do
        let(:user) { build :non_ezborrow_user }
      end
    end
    context 'when there is not a current user' do
      let(:user) { nil }
    end
  end
end
