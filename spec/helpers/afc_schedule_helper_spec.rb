require "rails_helper"
describe AFCScheduleHelper do
  let(:user) { build :afc_user }
  before { allow(helper).to receive(:current_user).and_return(user) }
  describe '#can_afc_schedule?' do
    subject { helper.can_afc_schedule? }
    context 'when there is a current user' do
      context 'and the user has permission to request an item from AFC' do
        it { should eql true }
      end
      context "but the user doesn't have permission to request an item from AFC" do
        let(:user) { build :non_afc_user }
        it { should eql false }
      end
    end
    context 'when there is not a current user' do
      let(:user) { nil }
      it { should eql false }
    end
  end
  describe "#afc_schedule_url" do
    subject { helper.afc_schedule_url }
    it { should eql "http://library.nyu.edu/forms/afc/faculty_loan.html" }
  end
  describe "#afc_schedule_authorizer" do
    subject { helper.send(:afc_schedule_authorizer) }
    it { should be_a AFCScheduleAuthorizer }
  end
end
