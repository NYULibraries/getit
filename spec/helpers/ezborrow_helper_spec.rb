require "rails_helper"
describe EZBorrowHelper do
  let(:user) { build :ezborrow_user }
  before { allow(helper).to receive(:current_user).and_return(user) }
  describe '#can_ezborrow?' do
    subject { helper.can_ezborrow? }
    context 'when there is a current user' do
      context 'and the user has permission to request an itme from E-ZBorrow' do
        it { should eql true }
      end
      context "but the user doesn't have permission to request an itme from E-ZBorrow" do
        let(:user) { build :non_ezborrow_user }
        it { should eql false }
      end
    end
    context 'when there is not a current user' do
      let(:user) { nil }
      it { should eql false }
    end
  end
  describe "#ezborrow_url" do
    let(:service_response) { build(:nyu_aleph_service_response) }
    let(:holding) { GetIt::Holding::NyuAleph.new(service_response) }
    subject { helper.ezborrow_url(holding) }
    it { should eql "https://login.library.nyu.edu/ezborrow?query=ti=Title" }
  end
  describe "#ezborrow_authorizer" do
    subject { helper.send(:ezborrow_authorizer) }
    it { should be_a EZBorrowAuthorizer }
  end
end
