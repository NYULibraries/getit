require 'rails_helper'
describe UserSession do
  let(:user) { build(:user) }
  describe '.pds_url' do
    subject { UserSession.pds_url }
    it { should eq (ENV['PDS_URL'] || 'https://login.library.nyu.edu') }
  end
  describe '.redirect_logout_url' do
    subject { UserSession.redirect_logout_url }
    it { should eq 'http://bobcat.library.nyu.edu' }
  end
  describe '.calling_system' do
    subject { UserSession.calling_system }
    it { should eq 'getit' }
  end
  describe '.institution_param_key' do
    subject { UserSession.institution_param_key }
    it { should eq 'umlaut.institution' }
  end
end
