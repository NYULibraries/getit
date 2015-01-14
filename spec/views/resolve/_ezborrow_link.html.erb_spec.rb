require 'rails_helper'
xdescribe 'resolve/_ezborrow_link' do
  let(:holding) { GetIt::HoldingManager.new(service_response).holding }
  subject { rendered }
  before do
    allow(view).to receive(:current_user).and_return(current_user)
    render '/resolve/ezborrow_link', {holding: holding}
  end
  context 'when there is a current user' do
    context "but the user isn't authorized to request items from E-ZBorrow" do
      let(:current_user) { build(:non_ezborrow_user) }
      context 'and the holding is in the NYU Bobst Reserve Collection' do
        let(:service_response) { create(:bobst_reserve_nyu_aleph_service_response) }
        it { should_not match /ezborrow-link/ }
        it { should_not match /E-ZBorrow/ }
        it { should_not match(/href="https:\/\/login(dev)?\.library\.nyu\.edu\/ezborrow\?query=/) }
      end
      context 'and the holding is in the NYU Bobst Reserve Collection' do
        let(:service_response) { create(:nyu_aleph_service_response) }
        it { should_not match /ezborrow-link/ }
        it { should_not match /E-ZBorrow/ }
        it { should_not match(/href="https:\/\/login(dev)?\.library\.nyu\.edu\/ezborrow\?query=/) }
      end
    end
    context "and the user is authorized to request items from E-ZBorrow" do
      let(:current_user) { build(:ezborrow_user) }
      context 'and the holding is in the NYU Bobst Reserve Collection' do
        let(:service_response) { create(:bobst_reserve_nyu_aleph_service_response) }
        it { should match /ezborrow-link/ }
        it { should match /E-ZBorrow/ }
        it { should match(/href="https:\/\/login(dev)?\.library\.nyu\.edu\/ezborrow\?query=/) }
      end
      context "and the holding isn't a reserves item" do
        let(:service_response) { create(:nyu_aleph_service_response) }
        it { should_not match /ezborrow-link/ }
        it { should_not match /E-ZBorrow/ }
        it { should_not match /href="http:\/\/login(dev)?\.library\.nyu\.edu\/ezborrow\?query="/ }
      end
    end
  end
  context 'when there is no current user' do
    let(:current_user) { nil }
    context 'and the holding is in the NYU Bobst Reserve Collection' do
      let(:service_response) { create(:bobst_reserve_nyu_aleph_service_response) }
      it { should_not match /ezborrow-link/ }
      it { should_not match /E-ZBorrow/ }
      it { should_not match(/href="https:\/\/login(dev)?\.library\.nyu\.edu\/ezborrow\?query=/) }
    end
    context "and the holding isn't a reserves item" do
      let(:service_response) { create(:nyu_aleph_service_response) }
      it { should_not match /ezborrow-link/ }
      it { should_not match /E-ZBorrow/ }
      it { should_not match(/href="https:\/\/login(dev)?\.library\.nyu\.edu\/ezborrow\?query=/) }
    end
  end
end
