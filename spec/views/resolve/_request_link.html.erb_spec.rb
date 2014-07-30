require 'rails_helper'
describe 'resolve/_request_link' do
  let(:service_response) { create(:nyu_aleph_service_response) }
  let(:request) { service_response.request }
  let(:holding) { GetIt::HoldingManager.new(service_response).holding }
  let(:url_for_request) { "http://url.for.request" }
  let(:current_user) { build(:aleph_user) }
  subject { rendered }
  before do
    allow(view).to receive(:url_for_request).and_return(url_for_request)
    allow(view).to receive(:current_user).and_return(current_user)
    render '/resolve/request_link', {holding: holding}
  end
  it { should match /request-link/ }
  it { should_not match /Login for Request Options/ }
  it { should match /Request/ }
  it { should match /href="http:\/\/test.host\/holding_requests\/new\/#{service_response.id}/ }
  context 'when there is no current user' do
    let(:current_user) { nil }
    it { should match /request-login-link/ }
    it { should match /Login for Request Options/ }
    it { should_not match /href="http:\/\/test.host\/holding_requests\/new\/#{service_response.id}"/ }
    it { should match /href="http:\/\/test.host\/login\?return_url=http%3A%2F%2Furl.for.request"/ }
    it { should_not match /target="_blank"/ }
  end
end
