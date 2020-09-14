require 'rails_helper'
describe ResolveController, vcr: {cassette_name: 'resolve'}  do
  let(:request) { create(:available_request) }
  let(:current_user) { nil }
  describe 'GET index' do
    before do
      allow(controller).to receive(:current_user).and_return(current_user)
      get :index, 'umlaut.request_id' => request.id
    end
    subject { response }
    it { should render_template('layouts/resolve') }
    it { should render_template('resolve/index') }
    context 'when rendering views' do
      render_views
      it { should render_template('resolve/_background_updater') }
      it { should render_template('resolve/_manually_entered_warning') }
      xit { should render_template('resolve/_citation') }
      it { should render_template('resolve/_search_inside') }
      it { should render_template('resolve/_fulltext') }
      xit { should render_template('resolve/_holding') }
      xit { should render_template('resolve/_wayfinder') }
      it { should render_template('resolve/_coins') }
      it { should render_template('resolve/_section_display') }
      it { should render_template('resolve/_service_errors') }
      it { should render_template('resolve/_modal') }
    end
  end
end
