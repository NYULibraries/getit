require 'rails_helper'
describe 'resolve/_background_updater' do
  let(:any_services_in_progress) { true }
  let(:request) { create(:available_request) }
  before do
    allow(view).to receive(:any_services_in_progress?).and_return(any_services_in_progress)
    allow(view).to receive(:current_primary_institution).and_return(Institutions.institutions[:NYU])
    allow(view).to receive(:umlaut_config).and_return(UmlautController.umlaut_config)
    render '/resolve/background_updater', {user_request: request}
  end
  subject { rendered }
  it { should match /umlaut_base = "http:\/\/test.host\/";/}
  it { should match /context_object = "umlaut\.request_id=#{request.id}&umlaut\.institution=NYU";/}
  it { should match /setTimeout\(function \(\) { updater\.update\(\); }, 250.0\);/}
  context 'when there are not any services in progress' do
    let(:any_services_in_progress) { false }
    it { should_not match /umlaut_base = "http:\/\/test.host\/";/}
    it { should_not match /context_object = "umlaut\.request_id=#{request.id}&umlaut\.institution=NYU";/}
    it { should_not match /setTimeout\(function \(\) { updater\.update\(\); }, 250.0\);/}
  end
end
