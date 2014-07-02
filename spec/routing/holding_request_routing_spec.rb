require 'rails_helper'
describe "routes for holding requests" do
  describe "GET /holding_requests" do
    let(:service_response) { create(:service_response) }
    subject { get("/holding_requests/new/#{service_response.id}") }
    it { should route_to(controller: "holding_requests", action: "new", service_response_id: "#{service_response.id}") }
  end
end