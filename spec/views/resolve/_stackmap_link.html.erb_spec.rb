require 'rails_helper'
describe 'resolve/_stackmap_link' do
  let(:holding) { GetIt::HoldingManager.new(service_response).holding }
  subject { rendered }
  before do
    allow(view).to receive(:current_user).and_return(nil)
    render '/resolve/stackmap_link', {holding: holding}
  end
  context 'when the service response is "available" in the New School Main Collection' do
    let(:service_response) do
      build(:available_new_school_main_collection_service_response)
    end
    it { should match /newschool-stackmap-link/ }
    it { should match /Map/ }
    it { should match /data-library="TNS University Center Library"/ }
    it { should match /data-location="Main Collection"/ }
    it { should match /data-callno="DS126 .M62 2002"/ }
  end
  context 'when the service response is "checked out" from the New School Main Collection' do
    let(:service_response) do
      build(:checked_out_new_school_main_collection_service_response)
    end
    it { should_not match /newschool-stackmap-link/ }
    it { should_not match /Map/ }
  end
  context 'when the service response is not in the New School Main Collection' do
    let(:service_response) do
      build(:nyu_aleph_service_response)
    end
    it { should_not match /newschool-stackmap-link/ }
    it { should_not match /Map/ }
  end
end
