require 'test_helper'
class Sfx4NsTest < ActiveSupport::TestCase
  test "readonly" do
    if Sfx4::Ns::Base.connection_configured?
      assert(Sfx4::Ns::AzTitle.new.readonly?)
      assert(Sfx4::Ns::AzTitleSearch.new.readonly?)
      assert(Sfx4::Ns::AzLetterGroup.new.readonly?)
      assert(Sfx4::Ns::AzExtraInfo.new.readonly?)
    end
  end
end
