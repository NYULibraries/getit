require 'test_helper'
class Sfx4SolrSearchTest < ActiveSupport::TestCase
  test "Sfx4 Base" do
    if Sfx4::Local::Base.connection_configured?
      assert_equal Sfx4::Local::Base, SearchMethods::Sfx4Solr::Local.sfx4_base
    end
  end
  
  test "Sfx4 Base NS" do
    if Sfx4::Ns::Base.connection_configured?
      assert_equal Sfx4::Ns::Base, SearchMethods::Sfx4Solr::Ns.sfx4_base
    end
  end
  
  test "Sfx4 Base CU" do
    if Sfx4::Cu::Base.connection_configured?
      assert_equal Sfx4::Cu::Base, SearchMethods::Sfx4Solr::Cu.sfx4_base
    end
  end
  
  test "fetch urls?" do
    if Sfx4::Local::Base.connection_configured?
      assert SearchMethods::Sfx4Solr::Local.fetch_urls?
    end
  end
  
  test "fetch urls? NS" do
    if Sfx4::Ns::Base.connection_configured?
      assert SearchMethods::Sfx4Solr::Ns.fetch_urls?
    end
  end
  
  test "fetch urls? CU" do
    if Sfx4::Cu::Base.connection_configured?
      assert SearchMethods::Sfx4Solr::Cu.fetch_urls?
    end
  end
  
  test "sfx4solr title contains search" do
    if Sfx4::Local::AzTitle.connection_configured?
      VCR.use_cassette('sfx4solr title contains search') do
        query = "economist"
        query = query.upcase
        [/^THE /, /^AN? /].each do |article|
          query.gsub! article, ""
        end
        results = Sfx4::Local::AzTitle.search do
          keywords query do
            fields(title: 1.0)
            boost 10.0 do
              with(:title_exact, query)
            end
          end
          order_by(:score, :desc)
          order_by(:title_sort, :asc)
        end.results
        assert_instance_of Array, results
        assert(results.size > 0)
        assert_equal "The Economist: Blogs", results.first.TITLE_DISPLAY
      end
    end
  end

  test "sfx4solr title starts with search" do
    if Sfx4::Local::AzTitle.connection_configured?
      VCR.use_cassette('sfx4solr title starts with search') do
        query = "economist"
        query = query.upcase
        [/^THE /, /^AN? /].each do |article|
          query.gsub! article, ""
        end
        results = Sfx4::Local::AzTitle.search do
          fulltext query do
            phrase_fields(title: 2.0)
            phrase_slop 0
            boost 10.0 do
              with(:title_exact).starting_with(query)
            end
            boost 5.0 do
              with(:title_exact).starting_with(query)
            end
            boost 5.0 do
              with(:title_exact, query)
            end
          end
          order_by(:score, :desc)
          order_by(:title_sort, :asc)
          
          paginate(:page => 1, :per_page => 20)
        end.results
        assert_instance_of Array, results
        assert(results.size > 0)
        assert_equal "The Economist: Blogs", results.first.TITLE_DISPLAY
      end
    end
  end

  test "sfx4solr exact search" do
    if Sfx4::Local::AzTitle.connection_configured?
      VCR.use_cassette('sfx4solr exact search') do
        query = "The New Yorker"
        query = query.upcase
        [/^THE /, /^AN? /].each do |article|
          query.gsub! article, ""
        end
        results = Sfx4::Local::AzTitle.search do
          fulltext query do
            phrase_fields(title: 2.0)
            phrase_slop 0
            boost 10.0 do
              with(:title_exact, query)
            end
          end
          order_by(:score, :desc)
          order_by(:title_sort, :asc)
        end.results
        assert_instance_of Array, results
        assert(results.size > 0)
        assert_equal "The Economist: Blogs", results.first.TITLE_DISPLAY
      end
    end
  end

  test "sfx4solr fulltext search NS" do
    if Sfx4::Ns::AzTitle.connection_configured?
      VCR.use_cassette('sfx4solr fulltext search NS') do
        query = "New York"
        results = Sfx4::Ns::AzTitle.search {fulltext query}.results
        assert_instance_of Array, results
        assert(results.size > 0)
      end
    end
  end
  
  test "sfx4solr starts with search NS" do
    if Sfx4::Ns::AzTitle.connection_configured?
      VCR.use_cassette('sfx4solr starts with search NS') do
        query = "Journal of"
        results = Sfx4::Ns::AzTitle.search {with(:title_exact).starting_with(query)}.results
        assert_instance_of Array, results
        assert(results.size > 0)
      end
    end
  end
  
  test "sfx4solr exact search NS" do
    if Sfx4::Ns::AzTitle.connection_configured?
      VCR.use_cassette('sfx4solr exact search NS') do
        query = "The New Yorker"
        results = Sfx4::Ns::AzTitle.search {with(:title_exact, query)}.results
        assert_instance_of Array, results
        assert(results.size > 0)
      end
    end
  end
  
  test "sfx4solr fulltext search CU" do
    if Sfx4::Cu::AzTitle.connection_configured?
      VCR.use_cassette('sfx4solr fulltext search CU') do
        query = "New York"
        results = Sfx4::Cu::AzTitle.search {fulltext query}.results
        assert_instance_of Array, results
        assert(results.size > 0)
      end
    end
  end

  test "sfx4solr starts with search CU" do
    if Sfx4::Cu::AzTitle.connection_configured?
      VCR.use_cassette('sfx4solr starts with search CU') do
        query = "Journal of"
        results = Sfx4::Cu::AzTitle.search {with(:title_exact).starting_with(query)}.results
        assert_instance_of Array, results
        assert(results.size > 0)
      end
    end
  end

  test "sfx4solr exact search CU" do
    if Sfx4::Cu::AzTitle.connection_configured?
      VCR.use_cassette('sfx4solr exact search CU') do
        query = "The New Yorker"
        results = Sfx4::Cu::AzTitle.search {with(:title_exact, query)}.results
        assert_instance_of Array, results
        assert(results.size > 0)
      end
    end
  end
end