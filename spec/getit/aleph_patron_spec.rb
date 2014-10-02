require 'rails_helper'
module GetIt
  describe AlephPatron do
    let(:user) { build :aleph_user }
    subject(:aleph_patron) { AlephPatron.new(user) }
    describe '#user' do
      subject { aleph_patron.user }
      it { should eq user }
    end
    describe '#id' do
      subject { aleph_patron.id }
      it { should eq (ENV['BOR_ID'] || 'BOR_ID') }
    end
    describe '#bor_status' do
      subject { aleph_patron.bor_status }
      it { should eq '51' }
    end
    describe '#record', vcr: {cassette_name: 'patron'} do
      let(:record_id) { 'NYU01000980206' }
      subject { aleph_patron.record(record_id) }
      it { should be_an Exlibris::Aleph::Patron::Record }
    end
    context 'when initialized without any arguments' do
      it 'should raise an ArgumentError' do
        expect { AlephPatron.new }.to raise_error ArgumentError
      end
    end
    context 'when initialized with a user argument' do
      context 'but the user argument is not a User' do
        let(:user) { "invalid" }
        it 'should raise an ArgumentError' do
          expect { subject }.to raise_error ArgumentError
        end
      end
      context 'and the user argument is a User' do
        context 'but the user does not have an aleph_id' do
          let(:user) { build :user, aleph_id: nil }
          it 'should raise an ArgumentError' do
            expect { subject }.to raise_error ArgumentError
          end
        end
      end
    end
  end
end
