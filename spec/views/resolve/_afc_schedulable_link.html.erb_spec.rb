require 'rails_helper'
describe 'resolve/_afc_schedule_link' do
  let(:holding) { GetIt::HoldingManager.new(service_response).holding }
  subject { rendered }
  before do
    allow(view).to receive(:current_user).and_return(current_user)
    render '/resolve/afc_schedule_link', {holding: holding}
  end
  context 'when there is a current user' do
    context "but the user isn't authorized to request items from AFC" do
      let(:current_user) { build(:non_afc_user) }
      context 'and the holding is in the AFC Main Collection' do
        let(:service_response) { create(:avery_fisher_nyu_aleph_service_response) }
        it { should_not match /afc-schedule-link/ }
        it { should_not match /Schedule/ }
        it { should_not match(/href="https:\/\/nyu\.qualtrics\.com\/jfe\/form\/SV_eKBzul896KmAWVL/) }
      end
      context "and the holding isn't an AFC item" do
        let(:service_response) { create(:nyu_aleph_service_response) }
        it { should_not match /afc-schedule-link/ }
        it { should_not match /Schedule/ }
        it { should_not match(/href="https:\/\/nyu\.qualtrics\.com\/jfe\/form\/SV_eKBzul896KmAWVL/) }
      end
    end
    context "and the user is authorized to request items from AFC" do
      let(:current_user) { build(:afc_user) }
      context 'and the holding is in the AFC Main Collection' do
        let(:service_response) { create(:avery_fisher_nyu_aleph_service_response) }
        it { should match /afc-schedule-link/ }
        it { should match /Schedule/ }
        it { should match(/href="https:\/\/nyu\.qualtrics\.com\/jfe\/form\/SV_eKBzul896KmAWVL/) }
      end
      context "and the holding isn't an AFC item" do
        let(:service_response) { create(:nyu_aleph_service_response) }
        it { should_not match /afc-schedule-link/ }
        it { should_not match /Schedule/ }
        it { should_not match /href="https:\/\/nyu\.qualtrics\.com\/jfe\/form\/SV_eKBzul896KmAWVL/ }
      end
    end
  end
  context 'when there is no current user' do
    let(:current_user) { nil }
    context 'and the holding is in the AFC Main Collection' do
      let(:service_response) { create(:avery_fisher_nyu_aleph_service_response) }
      it { should_not match /afc-schedule-link/ }
      it { should_not match /Schedule/ }
      it { should_not match(/href="https:\/\/nyu\.qualtrics\.com\/jfe\/form\/SV_eKBzul896KmAWVL/) }
    end
    context "and the holding isn't an AFC item" do
      let(:service_response) { create(:nyu_aleph_service_response) }
      it { should_not match /afc-schedule-link/ }
      it { should_not match /Schedule/ }
      it { should_not match(/href="https:\/\/nyu\.qualtrics\.com\/jfe\/form\/SV_eKBzul896KmAWVL/) }
    end
  end
end
