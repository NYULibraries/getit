require "rails_helper"
describe LayoutsHelper do

  describe '#application_javascript' do
    subject { helper.application_javascript }
    it { should eql '<script src="/assets/search.js"></script>' }
  end

  describe '#gauges?' do
    subject { helper.gauges? }
    it { should be false }
  end

  describe '#gauges_tracking_code' do
    subject { helper.gauges_tracking_code }
    it 'should not raise an error' do
      expect { subject }.not_to raise_error
    end
  end

  describe '#google_analytics?' do
    subject { helper.google_analytics? }
    it { should be false }
  end

  describe '#google_analytics_tracking_code' do
    subject { helper.google_analytics_tracking_code }
    it 'should not raise an error' do
      expect { subject }.not_to raise_error
    end
  end

  describe '#breadcrumbs' do
    subject { helper.breadcrumbs }
    it { should include '<a href="http://dev.library.nyu.edu">NYU Libraries</a>' }
    it { should include '<a href="http://bobcatdev.library.nyu.edu/nyu">BobCat</a>' }
    it { should include 'Journals' }
  end
end
