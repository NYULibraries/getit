require 'rails_helper'
describe ApplicationController  do
  let(:request) { create(:available_request) }
  describe '#url_for_request' do
    subject { controller.url_for_request(request) }
    it { should eq "http://test.host/resolve?umlaut.request_id=#{request.id}"}
  end

  describe '#institution_param' do
    subject { controller.send(:institution_param) }
    it { should eql nil }
  end
end
