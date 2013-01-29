require File.dirname(__FILE__) + '/../test_helper'
class Sfx4NyuTest < ActiveSupport::TestCase
  test "sfx4solr fulltext search" do
    VCR.use_cassette('sfx4solr fulltext search') do
      query = "New York"
      results = Sfx4::Local::AzTitle.search {fulltext query}.results
      assert_instance_of Array, results
      assert(results.size > 0)
    end
  end

  test "sfx4solr starts with search" do
    VCR.use_cassette('sfx4solr starts with search') do
      query = "Journal of"
      results = Sfx4::Local::AzTitle.search {with(:title_exact).starting_with(query)}.results
      assert_instance_of Array, results
      assert(results.size > 0)
    end
  end

  test "sfx4solr exact search" do
    VCR.use_cassette('sfx4solr exact search') do
      query = "The New Yorker"
      results = Sfx4::Local::AzTitle.search {with(:title_exact, query)}.results
      assert_instance_of Array, results
      assert(results.size > 0)
    end
  end

  test "sfx4solr fulltext search NS" do
    VCR.use_cassette('sfx4solr fulltext search NS') do
      query = "New York"
      results = Sfx4::Ns::AzTitle.search {fulltext query}.results
      assert_instance_of Array, results
      assert(results.size > 0)
    end
  end
  
  test "sfx4solr starts with search NS" do
    VCR.use_cassette('sfx4solr starts with search NS') do
      query = "Journal of"
      results = Sfx4::Ns::AzTitle.search {with(:title_exact).starting_with(query)}.results
      assert_instance_of Array, results
      assert(results.size > 0)
    end
  end
  
  test "sfx4solr exact search NS" do
    VCR.use_cassette('sfx4solr exact search NS') do
      query = "The New Yorker"
      results = Sfx4::Ns::AzTitle.search {with(:title_exact, query)}.results
      assert_instance_of Array, results
      assert(results.size > 0)
    end
  end
  
  test "sfx4solr fulltext search CU" do
    VCR.use_cassette('sfx4solr fulltext search CU') do
      query = "New York"
      results = Sfx4::Cu::AzTitle.search {fulltext query}.results
      assert_instance_of Array, results
      assert(results.size > 0)
    end
  end

  test "sfx4solr starts with search CU" do
    VCR.use_cassette('sfx4solr starts with search CU') do
      query = "Journal of"
      results = Sfx4::Cu::AzTitle.search {with(:title_exact).starting_with(query)}.results
      assert_instance_of Array, results
      assert(results.size > 0)
    end
  end

  test "sfx4solr exact search CU" do
    VCR.use_cassette('sfx4solr exact search CU') do
      query = "The New Yorker"
      results = Sfx4::Cu::AzTitle.search {with(:title_exact, query)}.results
      assert_instance_of Array, results
      assert(results.size > 0)
    end
  end
end