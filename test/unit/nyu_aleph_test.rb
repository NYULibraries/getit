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
  
  test "nyu_aleph new book" do
    assert_nothing_raised {
      holding = Exlibris::Primo::Holding.new()
      assert_not_nil(holding)
      holding = Exlibris::Primo::Holding.new({
        :display_type => "book",
        :library_code => "BREF",
        :title => "Digital divide : civic engagement, information poverty, and the Internet worldwide", 
        :record_id => "nyu_aleph000655588", 
        :source_id => "nyu_aleph", 
        :original_source_id => "NYU01",
        :source_record_id => "000655588"})
      assert_not_nil(holding)
      assert_equal("nyu_aleph000655588", holding.record_id)
      assert_nil(holding.call_number)
      assert_nil(holding.status_code)
      assert_nil(holding.status)
      assert((not holding.respond_to?(:adm_library_code)))
      assert((not holding.respond_to?(:sub_library_code)))
      assert((not holding.respond_to?(:sub_library)))
      assert((not holding.respond_to?(:collection_code)))
      assert_nil(holding.collection)
      assert((not holding.respond_to?(:item_status_code)))
      assert((not holding.respond_to?(:item_process_status_code)))
      assert((not holding.respond_to?(:circulation_status)))
      assert_equal("BREF", holding.library_code)
      assert_equal("NYU Bobst Reference", holding.library)
      assert(holding.coverage.empty?)
      VCR.use_cassette('nyu_aleph new book') do
        nyu_aleph = holding.to_source.expand.first
        assert_equal("(HN49.I56 N67 2001)", nyu_aleph.call_number)
        assert_equal("available", nyu_aleph.status_code)
        assert_equal("Available", nyu_aleph.status)
        assert_equal("NYU50", nyu_aleph.adm_library_code)
        assert_equal("BOBST", nyu_aleph.sub_library_code)
        assert_equal("NYU Bobst", nyu_aleph.sub_library)
        assert_equal("MAIN", nyu_aleph.collection_code)
        assert_equal("Main Collection", nyu_aleph.collection)
        assert_equal("01", nyu_aleph.item_status_code)
        assert_nil(nyu_aleph.item_process_status_code)
        assert_equal("On Shelf", nyu_aleph.circulation_status)
        assert_equal("BREF", nyu_aleph.library_code)
        assert_equal("NYU Bobst", nyu_aleph.library)
        assert(nyu_aleph.coverage.empty?)
      end
    }
  end
  
  test "nyu_aleph new journal" do
    assert_nothing_raised {
      holding = Exlibris::Primo::Holding.new()
      assert_not_nil(holding)
      holding = Exlibris::Primo::Holding.new({
        :display_type => "journal",
        :title => "New Yorker (New York, N.Y. : 1925)", 
        :library_code => "BOBST", 
        :record_id => "nyu_aleph002904404", 
        :source_id => "nyu_aleph", 
        :original_source_id => "NYU01",
        :source_record_id => "002904404"})
      assert_not_nil(holding)
      assert_equal("nyu_aleph002904404", holding.record_id)
      assert_nil(holding.call_number)
      assert_nil(holding.status_code)
      assert_nil(holding.status)
      assert((not holding.respond_to?(:adm_library_code)))
      assert((not holding.respond_to?(:sub_library_code)))
      assert((not holding.respond_to?(:sub_library)))
      assert((not holding.respond_to?(:collection_code)))
      assert_nil(holding.collection)
      assert((not holding.respond_to?(:item_status_code)))
      assert((not holding.respond_to?(:item_process_status_code)))
      assert((not holding.respond_to?(:circulation_status)))
      assert_equal("BOBST", holding.library_code)
      assert_equal("NYU Bobst", holding.library)
      assert(holding.coverage.empty?)
      VCR.use_cassette('nyu_aleph new journal') do
        nyu_aleph = holding.to_source.expand.first
        assert_nil(nyu_aleph.call_number)
        assert_nil(nyu_aleph.status_code)
        assert_nil(nyu_aleph.status)
        assert_nil(nyu_aleph.adm_library_code)
        assert_nil(nyu_aleph.sub_library_code)
        assert_nil(nyu_aleph.sub_library)
        assert_nil(nyu_aleph.collection_code)
        assert_nil(nyu_aleph.collection)
        assert_nil(nyu_aleph.item_status_code)
        assert_nil(nyu_aleph.item_process_status_code)
        assert_nil(nyu_aleph.circulation_status)
        assert_equal("BOBST", nyu_aleph.library_code)
        assert_equal("NYU Bobst", nyu_aleph.library)
        assert((not nyu_aleph.coverage.empty?), "Journal coverage is empty.")
        assert_equal(4, nyu_aleph.coverage.size)
      end
    }
  end
  
  test "nyu_aleph expand book" do
    assert_nothing_raised {
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
      VCR.use_cassette('nyu_aleph expand book') do
        nyu_alephs = holding.to_source.expand
      end
    }
  end
  
  test "nyu_aleph expand journal" do
    assert_nothing_raised {
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
      VCR.use_cassette('nyu_aleph expand journal') do
        nyu_alephs = holding.to_source.expand
      end
    }
  end
  
  test "nyu_aleph primo book source" do
    assert_nothing_raised {
      VCR.use_cassette('nyu_aleph primo book source') do
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
          assert(nyu_aleph.send(:expanding?), "Not expanding book.")
          assert(nyu_aleph.dedup?, "Not deduping book.")
        end
        assert_equal(3, primo_sources.size, "Primo sources size mismatch.")
        @primo_source_service.handle(request)
        request.dispatched_services.reload
        request.service_responses.reload
        holdings = request.get_service_type('holding', {:refresh => true})
        assert_equal(6, holdings.size)
      end
    }
  end
  
  test "nyu_aleph primo journal source" do
    assert_nothing_raised {
      VCR.use_cassette('nyu_aleph primo journal source') do
        request = requests(:the_new_yorker)
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
          assert((not nyu_aleph.send(:expanding?)), "Expanding journal.")
          assert((not nyu_aleph.dedup?), "Deduping journal.")
        end
        assert_equal(6, primo_sources.size, "Primo sources not size mismatch.")
        @primo_source_service.handle(request)
        request.dispatched_services.reload
        request.service_responses.reload
        holdings = request.get_service_type('holding', {:refresh => true})
        assert_equal(6, holdings.size)
      end
    }
  end
end