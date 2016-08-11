require 'rails_helper'
describe HoldingRequestsController, vcr: {cassette_name: 'holding requests'}  do
  let(:current_primary_institution) { Institutions.institutions[:NYU] }
  let(:service_response) { create(:nyu_aleph_service_response) }
  let(:user) { build(:aleph_user) }
  before {
    allow(controller).to receive(:current_primary_institution).and_return(current_primary_institution)
  }
  describe 'WHITELISTED_TYPES' do
    subject { HoldingRequestsController::WHITELISTED_TYPES }
    it { should be_an Array }
    it { should eq %w[available ill processing offsite on_order recall ezborrow] }
  end
  describe '#scan?' do
    before { allow(controller).to receive(:entire).and_return(entire) }
    subject { controller.scan? }
    context 'when entire is "yes"' do
      let(:entire) { 'yes' }
      it { should be false }
    end
    context 'when entire is "no"' do
      let(:entire) { 'no' }
      it { should be true }
    end
    context 'when entire is nil' do
      let(:entire) { nil }
      it { should be false }
    end
  end
  describe '#pickup_location' do
    let(:admin_library) { Exlibris::Aleph::AdminLibrary.new('NYU50') }
    let(:pickup_sub_library) { Exlibris::Aleph::SubLibrary.new('BOBST', 'NYU Bobst', admin_library) }
    before { allow(controller).to receive(:pickup_sub_library).and_return(pickup_sub_library) }
    subject { controller.pickup_location }
    it { should be_a Exlibris::Aleph::PickupLocation }
  end
  describe 'XHR GET new' do
    before do
      allow(controller).to receive(:current_user).and_return(user)
      xhr :get, :new, service_response_id: service_response
    end
    subject { response }
    it { should be_success }
    it 'should assign @holding_request' do
      expect(assigns(:holding_request)).to be_present
    end
    it 'should assign @authorizer' do
      expect(assigns(:authorizer)).to be_present
    end
    it { should render_template('new') }
    it { should_not render_template('layouts/bobcat') }
  end
  describe 'GET new' do
    before do
      allow(controller).to receive(:current_user).and_return(user)
      get :new, service_response_id: service_response
    end
    subject { response }
    it { should be_success }
    it 'should assign @holding_request' do
      expect(assigns(:holding_request)).to be_present
    end
    it 'should assign @authorizer' do
      expect(assigns(:authorizer)).to be_present
    end
    it { should render_template('new') }
    it { should render_template('layouts/bobcat') }
    context 'when the holding is on the shelf' do
      let(:service_response) { create(:on_shelf_nyu_aleph_service_response) }
    end
    context 'when there is no logged in user' do
      let(:user) { nil }
      it { should_not be_success }
      it 'should be unauthorized' do
        expect(subject.message).to eq "Unauthorized"
      end
      it 'should have a 401 status' do
        expect(subject.status).to be 401
      end
      it 'should not assign @holding_request' do
        expect(assigns(:holding_request)).not_to be_present
      end
      it 'should not assign @authorizer' do
        expect(assigns(:authorizer)).not_to be_present
      end
      it { should_not render_template('new') }
    end
    context 'when the service response is missing' do
      let(:service_response) { -1 }
      it { should_not be_success }
      it { should be_bad_request }
      it 'should not assign @holding_request' do
        expect(assigns(:holding_request)).not_to be_present
      end
      it 'should not assign @authorizer' do
        expect(assigns(:authorizer)).not_to be_present
      end
      it { should_not render_template('new') }
    end
  end
  describe 'POST create' do
    let(:type) { 'recall' }
    let(:pickup_location) do
      Exlibris::Aleph::PickupLocation.new('BOBST', 'NYU Bobst')
    end
    let(:entire) { 'yes' }
    before do
      allow(controller).to receive(:current_user).and_return(user)
      post :create, service_response_id: service_response,
        type: type, entire: entire, pickup_location: pickup_location
    end
    subject { response }
    context 'when the request type is recall' do
      context 'and the user has ill and ezborrow permissions' do
        it 'should throw an access denied error' do
          expect(subject.status).to be 401
        end
      end
      context 'and the user does not have ill and ezborrow permissions' do
        let(:user) { build(:non_ezborrow_user) }
        it { should be_redirect }
        it("should have a 302 status") { expect(subject.status).to be(302) }
        it { should redirect_to(holding_request_url(service_response, entire: 'yes', pickup_location: 'BOBST')) }
      end
    end
    context 'when the request type is ILL' do
      let(:type) { 'ill' }
      it { should be_redirect }
      it("should have a 302 status") { expect(subject.status).to be(302) }
      it 'should redirect to ILL' do
        expect(subject.location).to match /^http:\/\/ill(dev)?\.library\.nyu\.edu\/illiad\/illiad\.dll\/OpenURL\?/
      end
    end
    context 'when the request type is E-ZBorrow' do
      let(:type) { 'ezborrow' }
      it { should be_redirect }
      it("should have a 302 status") { expect(subject.status).to be(302) }
      context 'when institution is NYU' do
        it 'should redirect to EZborrow script in PDS' do
          expect(subject.location).to match /^https:\/\/pds(dev)?\.library\.nyu\.edu\/ezborrow\?ls=NYU&query=/
        end
      end
      context 'when institution is NS' do
        let(:current_primary_institution) { Institutions.institutions[:NS] }
        it 'should redirect to EZborrow script in PDS' do
          expect(subject.location).to match /^https:\/\/pds(dev)?\.library\.nyu\.edu\/ezborrow\?ls=THENEWSCHOOL&query=/
        end
      end
    end
    context 'when the request type is available ' do
      let(:type) { 'available' }
      context 'and the request is for a partial scan' do
        let(:entire) { 'no' }
        context 'and the pickup location is ISAW' do
          let(:service_response) { create(:isaw_nyu_aleph_service_response) }
          let(:pickup_location) do
            Exlibris::Aleph::PickupLocation.new('NISAW', 'NYU Inst Study Ancient World')
          end
          it { should redirect_to(holding_request_url(service_response, entire: 'no', pickup_location: 'NISAW')) }
        end
      end
    end
  end
end
