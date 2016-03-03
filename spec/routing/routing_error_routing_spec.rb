require 'rails_helper'
describe "routes for holding requests" do
  describe "GET /doestnotexist" do
    subject { get('/doesnotexist') }
    it { should route_to({controller: 'application', action: 'routing_error', path: 'doesnotexist'}) }
  end
end
