require 'rails_helper'
describe User do
  describe User::VALID_PROVIDERS do
    subject { User::VALID_PROVIDERS }
    it { should include 'nyu_shibboleth' }
    it { should include 'new_school_ldap' }
    it { should include 'aleph' }
    it { should include 'twitter' }
    it { should include 'facebook' }
  end

  subject(:user) { build(:user) }
  it { should be_a User }

  context 'when the provider code is given' do
    subject(:user) { build(:user, provider: provider) }
    context 'and it is invalid' do
      let(:provider) { 'invalid' }
      it { should_not be_valid }
    end
    context 'and it is nil' do
      let(:provider) { nil }
      it { should_not be_valid }
    end
    context 'and it is empty' do
      let(:provider) { '' }
      it { should_not be_valid }
    end
    context 'and it is valid' do
      let(:provider) { 'aleph' }
      it { should be_valid }
    end
  end

end
