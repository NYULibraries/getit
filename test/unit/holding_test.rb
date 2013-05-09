require 'test_helper'
class HoldingTest < ActiveSupport::TestCase
  setup do
    @requested_holding = Holding.new(service_responses(:nyu_primo_naked_statistics))
    @available_holding = Holding.new(service_responses(:nyu_aleph_available_book))
    @offsite_holding = Holding.new(service_responses(:nyu_aleph_offsite_book))
    @checked_out_holding = Holding.new(service_responses(:nyu_aleph_recall_book))
    @in_processing_holding = Holding.new(service_responses(:nyu_aleph_in_processing_book))
    # @on_order_holding = Holding.new(service_responses(:nyu_aleph_on_order_book))
    @ill_holding = Holding.new(service_responses(:nyu_aleph_ill_holding))
  end

  test "available" do
    holding = @available_holding
    assert(holding.available?, "Should be available but not.")
    assert((not holding.offsite?), "Should not be offsite but is")
    assert((not holding.checked_out?), "Should not be checked out but is")
    assert((not holding.on_order?), "Should not be on order but is")
    assert((not holding.in_processing?), "Should not be in processing but is")
    assert((not holding.ill?), "Should not be ill but is")
    assert((not holding.requested?), "Should not be requested but is")
  end

  test "offsite" do
    holding = @offsite_holding
    assert(holding.offsite?, "Should be offsite but not.")
    assert((not holding.available?), "Should not be available but is")
    assert((not holding.checked_out?), "Should not be checked out but is")
    assert((not holding.on_order?), "Should not be on order but is")
    assert((not holding.in_processing?), "Should not be in processing but is")
    assert((not holding.ill?), "Should not be ill but is")
    assert((not holding.requested?), "Should not be requested but is")
  end

  test "checked out" do
    holding = @checked_out_holding
    assert(holding.checked_out?, "Should be checked out but not.")
    assert(holding.recallable?, "Should be recallable but not.")
    assert(holding.ill?, "Should be ill but not.")
    assert((not holding.available?), "Should not be available but is")
    assert((not holding.offsite?), "Should not be offsite but is")
    assert((not holding.on_order?), "Should not be on order but is")
    assert((not holding.in_processing?), "Should not be in processing but is")
    assert((not holding.requested?), "Should not be requested but is")
  end

  test "in processing" do
    holding = @in_processing_holding
    assert(holding.in_processing?, "Should be in processing but not.")
    assert(holding.ill?, "Should be ill but not.")
    assert((not holding.offsite?), "Should not be available but is")
    assert((not holding.checked_out?), "Should not be checked out but is")
    assert((not holding.on_order?), "Should not be on order but is")
    assert((not holding.checked_out?), "Should not be checked out but is")
    assert((not holding.requested?), "Should not be requested but is")
  end

  test "ill" do
    holding = @ill_holding
    assert(holding.ill?, "Should be ill but not.")
    assert((not holding.offsite?), "Should not be available but is")
    assert((not holding.checked_out?), "Should not be checked out but is")
    assert((not holding.on_order?), "Should not be on order but is")
    assert((not holding.checked_out?), "Should not be checked out but is")
    assert((not holding.in_processing?), "Should not be in processing but is")
    assert((not holding.requested?), "Should not be requested but is")
  end

  test "requested" do
    holding = @requested_holding
    assert(holding.requested?, "Should be requested but not.")
    assert(holding.recallable?, "Should be recallable but not.")
    assert(holding.ill?, "Should be ill but not.")
    assert((not holding.offsite?), "Should not be available but is")
    assert((not holding.checked_out?), "Should not be checked out but is")
    assert((not holding.on_order?), "Should not be on order but is")
    assert((not holding.checked_out?), "Should not be checked out but is")
    assert((not holding.in_processing?), "Should not be in processing but is")
  end
end