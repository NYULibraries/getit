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
    nyu_aleph = Exlibris::Primo::Source::NyuAleph.new()
    assert_not_nil(nyu_aleph)
    nyu_aleph = Exlibris::Primo::Source::NyuAleph.new({
      :config => @config,
      :display_type => "book",
      :title => "Digital divide : civic engagement, information poverty, and the Internet worldwide", 
      :record_id => "nyu_aleph000655588", 
      :source_id => "nyu_aleph", 
      :original_source_id => "NYU01",
      :source_record_id => "000655588"})
    assert_not_nil(nyu_aleph)
    assert_equal("nyu_aleph000655588", nyu_aleph.record_id)
    assert_nil(nyu_aleph.id_two)
    nyu_aleph = nyu_aleph.expand.first
    assert_equal("(HN49.I56 N67 2001)", nyu_aleph.id_two)
    assert_equal("available", nyu_aleph.status_code)
    assert_equal("Available", nyu_aleph.status)
  end
  
  test "nyu_aleph_primo_source" do
  end
end