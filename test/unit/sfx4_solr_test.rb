  require File.dirname(__FILE__) + '/../test_helper'
  class Sfx4NyuTest < ActiveSupport::TestCase
    def setup
      @sfxtst_db = {
        "adapter" => "mysql2",
        "host" => "sfx1.bobst.nyu.edu",
        "port" => 3310,
        "database" => "sfxtst41",
        "username" => "umlaut",
        "password" => "LLBZMn2qw2n4",
        "encoding" => "utf8" }
      @sfxlcl_db = {
        "adapter" => "mysql2",
        "host" => "sfx1.bobst.nyu.edu",
        "port" => 3310,
        "database" => "sfxlcl41",
        "username" => "umlaut",
        "password" => "LLBZMn2qw2n4",
        "encoding" => "utf8" }
      @object_ids = ["2670000000038116", "1000000000237151"]
    end
    
    test "fulltext search" do
      query = "New York"
      results = Sfx4::Local::AzTitle.search {fulltext query}.results
      assert_instance_of Array, results
      assert(results.size > 0)
    end

    test "starts with search" do
      query = "Journal of"
      results = Sfx4::Local::AzTitle.search {with(:title_exact).starting_with(query)}.results
      assert_instance_of Array, results
      assert(results.size > 0)
    end

    test "exact search" do
      query = "The New Yorker"
      results = Sfx4::Local::AzTitle.search {with(:title_exact, query)}.results
      assert_instance_of Array, results
      assert(results.size > 0)
    end
  end