require 'rails_helper'
describe 'routes for users' do
  describe 'GET /users' do
    let(:user) { create(:user) }
    subject { get("/users/#{user.provider}/#{user.id}") }
    it do
      should route_to({
        controller: 'users',
        action: 'show',
        provider: "#{user.provider}",
        id: "#{user.id}"
      })
    end
  end

  describe 'GET /users/auth/nyulibraries' do
    subject { get('/users/auth/nyulibraries') }
    it do
      should route_to({
        controller: 'users',
        action: 'passthru',
        provider: 'nyulibraries'
      })
    end
  end

  describe 'POST /users/auth/nyulibraries' do
    subject { post('/users/auth/nyulibraries') }
    it do
      should route_to({
        controller: 'users',
        action: 'passthru',
        provider: 'nyulibraries'
      })
    end
  end

  describe 'GET /users/auth/nyulibraries/callback' do
    subject { get('/users/auth/nyulibraries/callback') }
    it { should route_to({controller: 'users', action: 'nyulibraries'}) }
  end

  describe 'POST /users/auth/nyulibraries/callback' do
    subject { post('/users/auth/nyulibraries/callback') }
    it { should route_to({controller: 'users', action: 'nyulibraries'}) }
  end
end
