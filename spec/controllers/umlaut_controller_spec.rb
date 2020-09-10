require 'rails_helper'
describe UmlautController  do
  let(:request) { create(:available_request) }
  let(:current_primary_institution) { Institutions.institutions[:NYU] }
  describe '#institutional_config' do
    before do
      allow(controller).to receive(:current_primary_institution).and_return(current_primary_institution)
    end
    subject { controller.institutional_config }
    context 'when the current primary institution is NYU' do
      its([:sfx,:sfx_base_url]) { should eql 'http://sfx.library.nyu.edu/sfxlcl41?' }
      xcontext 'and user is not logged in' do
        its([:borrow_direct, :local_availability_check]) { should be_a Proc }
      end
      xcontext 'and user is logged in' do
        before do
          @request.env["devise.mapping"] = Devise.mappings[:user]
          sign_in create(:ezborrow_user)
        end
        its([:borrow_direct, :local_availability_check]) { should be_a Proc }
      end
    end
    context 'when the current primary institution is NS' do
      let(:current_primary_institution) { Institutions.institutions[:NS] }
      its([:sfx,:sfx_base_url]) { should eql 'http://sfx4.library.newschool.edu/ns?' }
    end
    context 'when the current primary institution is CU' do
      let(:current_primary_institution) { Institutions.institutions[:CU] }
      its([:sfx,:sfx_base_url]) { should eql 'http://sfx.library.nyu.edu/sfxcooper?' }
    end
  end
  describe '#requestable?', vcr: {cassette_name: 'requestable'} do
    let(:current_user) { create(:user) }
    let(:service_response) { build(:nyu_aleph_service_response) }
    let(:holding) { GetIt::Holding::NyuAleph.new(service_response) }
    subject { controller.requestable?(holding) }
    context 'when the holding is not an nyu aleph holding' do
      let(:holding) { nil }
      it { should be false }
    end
    context 'when the holding is an nyu aleph holding' do
      context 'and the current user is present' do
        before do
          @request.env["devise.mapping"] = Devise.mappings[:user]
          sign_in current_user
        end
        context 'and has permissions to request the holding' do
          it { should be true }
        end
      end
      context 'and the current user is nil' do
        context 'and the holding is requestable' do
          it { should be true }
        end
      end
    end
  end
  describe '#create_collection' do
    subject { controller.send(:create_collection) }
  end
end
