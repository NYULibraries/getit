require 'test_helper'
class Sfx4SolrSearchCuTest < ActiveSupport::TestCase
  include SearchMethods::Sfx4Solr::Cu
  test "Sfx4 Base CU" do
    if Sfx4::Cu::Base.connection_configured?
      assert_equal Sfx4::Cu::Base, SearchMethods::Sfx4Solr::Cu.sfx4_base
    end
  end
  
  test "fetch urls? CU" do
    if Sfx4::Cu::Base.connection_configured?
      assert SearchMethods::Sfx4Solr::Cu.fetch_urls?
    end
  end
  
  test "sfx4solr title contains search CU" do
    if Sfx4::Cu::AzTitle.connection_configured?
      VCR.use_cassette('sfx4solr title contains search CU') do
        query = "New York"
        search_type = "contains"
        first_result = "New York"
        assert_equal first_result, _search_by_title(query, search_type).hits.first.stored(:title_display)
      end
    end
  end

  test "sfx4solr title starts with search CU" do
    if Sfx4::Cu::AzTitle.connection_configured?
      VCR.use_cassette('sfx4solr title starts with search CU') do
        query = "Journal of"
        search_type = "begins"
        first_result = "Journal of accountancy"
        assert_equal first_result, _search_by_title(query, search_type).hits.first.stored(:title_display)
      end
    end
  end

  test "sfx4solr title exact search CU" do
    if Sfx4::Cu::AzTitle.connection_configured?
      VCR.use_cassette('sfx4solr title exact search CU') do
        query = "The New Yorker"
        search_type = "exact"
        first_result = "The New Yorker"
        assert_equal first_result, _search_by_title(query, search_type).hits.first.stored(:title_display)
      end
    end
  end
end
