require 'rails_helper'
describe User do
  describe User::VALID_INSTITUTION_CODES do
    subject { User::VALID_INSTITUTION_CODES }
    it { should include 'NYU' }
    it { should include 'NYUAD' }
    it { should include 'NYUSH' }
    it { should include 'NS' }
    it { should include 'CU' }
    it { should include 'NYSID' }
  end

  describe 'scopes' do
    before { create(:user) }
    describe 'inactive' do
      subject { User.inactive.count }
      it { is_expected.to eql 0 }
    end
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
