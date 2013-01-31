require 'test_helper'
class Sfx4CuTest < ActiveSupport::TestCase
  test "readonly" do
    if Sfx4::Cu::Base.connection_configured?
      assert(Sfx4::Cu::AzTitle.new.readonly?)
      assert(Sfx4::Cu::AzTitleSearch.new.readonly?)
      assert(Sfx4::Cu::AzLetterGroup.new.readonly?)
      assert(Sfx4::Cu::AzExtraInfo.new.readonly?)
    end
  end
end
