# encoding: utf-8
require 'test_helper'
class NyuAlephTest < ActiveSupport::TestCase
  # fixtures :users, :requests, :referents, :referent_values
  # setup :activate_authlogic

  def setup
    @config = YAML.load_file("#{Rails.root}/config/primo.yml")
    ServiceTypeValue.load_values!
    @primo_service = ServiceStore.instantiate_service!("NYU_Primo", nil)
    @primo_source_service = ServiceStore.instantiate_service!("NYU_Primo_Source", nil)
  end
  
  test "nyu_aleph_new" do
    holding = Exlibris::Primo::Holding.new()
    assert_not_nil(holding)
    holding = Exlibris::Primo::Holding.new({
      :display_type => "book",
      :title => "Digital divide : civic engagement, information poverty, and the Internet worldwide", 
      :record_id => "nyu_aleph000655588", 
      :source_id => "nyu_aleph", 
      :original_source_id => "NYU01",
      :source_record_id => "000655588"})
    assert_not_nil(holding)
    assert_equal("nyu_aleph000655588", holding.record_id)
    assert_nil(holding.call_number)
    nyu_aleph = holding.to_source.expand.first
    assert_equal("(HN49.I56 N67 2001)", nyu_aleph.call_number)
    assert_equal("available", nyu_aleph.status_code)
    assert_equal("Available", nyu_aleph.status)
    assert_equal("BOBST", nyu_aleph.sub_library_code)
    assert_equal("NYU Bobst", nyu_aleph.sub_library)
    assert_equal("NYU Bobst", nyu_aleph.library)
  end
  
  test "nyu_aleph_expand_book" do
    holding = Exlibris::Primo::Holding.new({
      :display_type => "book",
      :title => "Digital divide : civic engagement, information poverty, and the Internet worldwide", 
      :record_id => "nyu_aleph000655588", 
      :source_id => "nyu_aleph", 
      :original_source_id => "NYU01",
      :source_record_id => "000655588"})
    assert_not_nil(holding)
    assert_equal("nyu_aleph000655588", holding.record_id)
    assert_nil(holding.call_number)
    nyu_alephs = holding.to_source.expand
  end
  
  test "nyu_aleph_expand_journal" do
    holding = Exlibris::Primo::Holding.new({
      :display_type => "journal",
      :title => "New Yorker (New York, N.Y. : 1925)", 
      :record_id => "nyu_aleph002904404", 
      :source_id => "nyu_aleph", 
      :original_source_id => "NYU01",
      :source_record_id => "002904404"})
    assert_not_nil(holding)
    assert_equal("nyu_aleph002904404", holding.record_id)
    assert_nil(holding.call_number)
    nyu_alephs = holding.to_source.expand
  end
  
  test "nyu_aleph_primo_book_source" do
    assert_nothing_raised {
      request = requests(:frankenstein)
      @primo_service.handle(request)
      request.dispatched_services.reload
      request.service_responses.reload
      holdings = request.get_service_type('holding', {:refresh => true})
      assert(holdings.empty?, "Holdings not empty.")
      primo_sources = request.get_service_type('primo_source', {:refresh => true})
      primo_sources.each do |primo_source|
        nyu_aleph = primo_source.view_data
        # This is a journal, so we shouldn't be expanding
        # or deduping.
        assert(nyu_aleph.send(:expanding?), "Not expanding book, WTF!")
        assert(nyu_aleph.dedup?, "Not deduping book, WTF!")
      end
      assert_equal(3, primo_sources.size, "Primo sources size mismatch.")
      @primo_source_service.handle(request)
      request.dispatched_services.reload
      request.service_responses.reload
      holdings = request.get_service_type('holding', {:refresh => true})
      assert_equal(6, holdings.size)
    }
  end
  
  test "nyu_aleph_primo_journal_source" do
    assert_nothing_raised {
      request = requests(:the_new_yorker_request)
      @primo_service.handle(request)
      request.dispatched_services.reload
      request.service_responses.reload
      holdings = request.get_service_type('holding', {:refresh => true})
      assert(holdings.empty?, "Holdings not empty.")
      primo_sources = request.get_service_type('primo_source', {:refresh => true})
      primo_sources.each do |primo_source|
        nyu_aleph = primo_source.view_data
        # This is a journal, so we shouldn't be expanding
        # or deduping.
        assert((not nyu_aleph.send(:expanding?)), "Expanding journal, WTF!")
        assert((not nyu_aleph.dedup?), "Deduping journal, WTF!")
      end
      assert_equal(6, primo_sources.size, "Primo sources not size mismatch.")
      @primo_source_service.handle(request)
      request.dispatched_services.reload
      request.service_responses.reload
      holdings = request.get_service_type('holding', {:refresh => true})
      assert_equal(6, holdings.size)
    }
  end
end