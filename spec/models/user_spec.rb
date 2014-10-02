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

  describe User::VALID_INSTITUTION_CODES do
    subject { User::VALID_INSTITUTION_CODES }
    it { should include 'NYU' }
    it { should include 'NYUAD' }
    it { should include 'NYUSH' }
    it { should include 'NS' }
    it { should include 'CU' }
    it { should include 'NYSID' }
  end

  subject(:user) { build(:user) }
  it { should be_a User }

  context 'when the institution code is given' do
    subject(:user) { build(:user, institution_code: institution_code) }
    context 'and it is invalid' do
      let(:institution_code) { 'invalid' }
      it { should_not be_valid }
    end
    context 'and it is nil' do
      let(:institution_code) { nil }
      it { should be_valid }
    end
    context 'and it is empty' do
      let(:institution_code) { '' }
      it { should be_valid }
    end
    context 'and it is valid' do
      let(:institution_code) { 'NYU' }
      it { should be_valid }
    end
  end

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

  describe '#institution' do
    let(:user) { build(:user, institution_code: institution_code) }
    subject { user.institution }
    context 'when the institution_code is nil' do
      let(:institution_code){ nil }
      it { should be_nil }
    end
    context 'when the institution_code is not nil' do
      let(:institution_code){ 'NYU' }
      it { should be_an Institutions::Institution }
    end
  end
end
