require 'rails_helper'
describe ApplicationController  do
  let(:request) { create(:available_request) }
  describe '#url_for_request' do
    subject { controller.url_for_request(request) }
    it { should eq "http://test.host/resolve?umlaut.request_id=#{request.id}"}
  end
end
