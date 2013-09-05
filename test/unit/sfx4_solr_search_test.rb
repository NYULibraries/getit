#!/bin/env ruby
# encoding: utf-8
require 'test_helper'
class Sfx4SolrSearchTest < ActiveSupport::TestCase
  include SearchMethods::Sfx4Solr::Local
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
        search_type = "contains"
        first_result = "The Economist: Blogs"
        assert_equal first_result, _search_by_title(query, search_type).hits.first.stored(:title_display)
      end
    end
  end

  test "sfx4solr title starts with search" do
    if Sfx4::Local::AzTitle.connection_configured?
      VCR.use_cassette('sfx4solr title starts with search') do
        query = "economist"
        search_type = "begins"
        first_result = "The Economist: Blogs"
        assert_equal first_result, _search_by_title(query, search_type).hits.first.stored(:title_display)
      end
    end
  end

  test "sfx4solr title exact search" do
    if Sfx4::Local::AzTitle.connection_configured?
      VCR.use_cassette('sfx4solr title exact search') do
        query = "The New Yorker"
        search_type = "exact"
        first_result = "The New - Yorker (1836-1841)‎"
        assert_equal first_result, _search_by_title(query, search_type).hits.first.stored(:title_display)
      end
    end
  end

  test "sfx4solr title contains search NS" do
    if Sfx4::Ns::AzTitle.connection_configured?
      VCR.use_cassette('sfx4solr title contains search NS') do
        query = "New York"
        search_type = "contains"
        first_result = "The Economist: Blogs"
        assert_equal first_result, _search_by_title(query, search_type).hits.first.stored(:title_display)
      end
    end
  end
  
  test "sfx4solr title starts with search NS" do
    if Sfx4::Ns::AzTitle.connection_configured?
      VCR.use_cassette('sfx4solr title starts with search NS') do
        query = "Journal of"
        search_type = "begins"
        first_result = "The Economist: Blogs"
        assert_equal first_result, _search_by_title(query, search_type).hits.first.stored(:title_display)
      end
    end
  end
  
  test "sfx4solr title exact search NS" do
    if Sfx4::Ns::AzTitle.connection_configured?
      VCR.use_cassette('sfx4solr title exact search NS') do
        query = "The New Yorker"
        search_type = "exact"
        first_result = "The New - Yorker (1836-1841)‎"
        assert_equal first_result, _search_by_title(query, search_type).hits.first.stored(:title_display)
      end
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
        first_result = "The New - Yorker (1836-1841)‎"
        assert_equal first_result, _search_by_title(query, search_type).hits.first.stored(:title_display)
      end
    end
  end
end