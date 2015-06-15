require 'rails_helper'
describe ApplicationController  do
  let(:request) { create(:available_request) }
  describe "#current_user_dev" do
    subject { controller.current_user_dev }
    context "when the dev user is not loaded" do
      it { should be_nil }
    end
    context "when the dev user is loaded into the DB" do
      before { create(:user, username: "dev123" )}
      it { should be_a User }
    end
  end
  describe '#url_for_request' do
    subject { controller.url_for_request(request) }
    it { should eq "http://test.host/resolve?umlaut.request_id=#{request.id}"}
  end
end
