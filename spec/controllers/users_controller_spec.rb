require 'rails_helper'
describe UsersController  do
  before { request.env["devise.mapping"] = Devise.mappings[:user] }
  describe 'GET nyulibraries' do
    before { get :nyulibraries }
    subject { response }
    context 'when omniauth.auth is not present in the request environment' do
      before { request.env['omniauth.auth'] = nil }
      it { should be_bad_request }
    end
    context 'when omniauth.auth is present in the request environment' do
    end
  end
end
