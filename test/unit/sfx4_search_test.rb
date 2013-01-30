require 'test_helper'
class Sfx4SearchTest < ActiveSupport::TestCase
  test "Sfx4 Base" do
    if Sfx4::Local::Base.connection_configured?
      assert_equal Sfx4::Local::Base, SearchMethods::Sfx4.sfx4_base
    end
  end
  
  test "Sfx4 Base NS" do
    if Sfx4::Ns::Base.connection_configured?
      assert_equal Sfx4::Ns::Base, SearchMethods::Sfx4Ns.sfx4_base
    end
  end
  
  test "Sfx4 Base CU" do
    if Sfx4::Cu::Base.connection_configured?
      assert_equal Sfx4::Cu::Base, SearchMethods::Sfx4Cu.sfx4_base
    end
  end
  
  test "fetch urls?" do
    if Sfx4::Local::Base.connection_configured?
      assert SearchMethods::Sfx4.fetch_urls?
    end
  end
  
  test "fetch urls? NS" do
    if Sfx4::Ns::Base.connection_configured?
      assert SearchMethods::Sfx4Ns.fetch_urls?
    end
  end
  
  test "fetch urls? CU" do
    if Sfx4::Cu::Base.connection_configured?
      assert SearchMethods::Sfx4Cu.fetch_urls?
    end
  end
  
  test "fetch urls" do
    if Sfx4::Local::Base.connection_configured?
      assert((not SearchMethods::Sfx4.fetch_urls.empty?))
    end
  end
  
  test "fetch urls NS" do
    if Sfx4::Ns::Base.connection_configured?
      assert((not SearchMethods::Sfx4Ns.fetch_urls.empty?))
    end
  end
  
  test "fetch urls CU" do
    if Sfx4::Cu::Base.connection_configured?
      assert((not SearchMethods::Sfx4Cu.fetch_urls.empty?))
    end
  end
end
