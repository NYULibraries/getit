require 'rails_helper'
describe UmlautController  do
  let(:request) { create(:available_request) }
  describe '#institutional_config' do
    subject { controller.institutional_config }
    context 'when the current primary institution is nil' do
    end
    context 'when the current primary institution is NYU' do
    end
  end
  describe '#requestable?' do
    let(:current_user) {}
    let(:holding) {}
    subject { controller.requestable?(holding) }
    context 'when the current user is present' do
      context 'and permissions to request the holding' do
      end
      context 'and does not permissions to request the holding' do
      end
    end
    context 'when the current user is nil' do
    end
  end
  describe '#create_collection' do
    subject { controller.send(:create_collection) }
  end
end
