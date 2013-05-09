require 'test_helper'
class HoldingRequestAuthorizerTest < ActiveSupport::TestCase
  setup do
    @requested_holding = Holding.new(service_responses(:nyu_primo_naked_statistics))
    @available_holding = Holding.new(service_responses(:nyu_aleph_available_book))
    @offsite_holding = Holding.new(service_responses(:nyu_aleph_offsite_book))
    @checked_out_holding = Holding.new(service_responses(:nyu_aleph_recall_book))
    @in_processing_holding = Holding.new(service_responses(:nyu_aleph_in_processing_book))
    # @on_order_holding = Holding.new(service_responses(:nyu_aleph_on_order_book))
    @ill_holding = Holding.new(service_responses(:nyu_aleph_ill_holding))
    @user = users(:uid)
  end

  test "available holding, user with on shelf and hold permissions" do
    holding = @available_holding
    VCR.use_cassette('user aleph permissions') do
      authorizer = HoldingRequestAuthorizer.new(holding, @user)
      assert(authorizer.available?, "Should be available but not.")
      assert((not authorizer.offsite?), "Should not be offsite but is")
      assert((not authorizer.recallable?), "Should not be recallable but is")
      assert((not authorizer.on_order?), "Should not be on order but is")
      assert((not authorizer.in_processing?), "Should not be in processing but is")
      assert((not authorizer.ill?), "Should not be ill but is")
    end
  end

  test "offsite holding, user with on shelf and hold permissions" do
    holding = @offsite_holding
    authorizer = HoldingRequestAuthorizer.new(holding, @user)
    VCR.use_cassette('user aleph permissions') do
      assert(authorizer.offsite?, "Should be offsite but not.")
      assert((not authorizer.available?), "Should not be available but is")
      assert((not authorizer.recallable?), "Should not be recallable but is")
      assert((not authorizer.on_order?), "Should not be on order but is")
      assert((not authorizer.in_processing?), "Should not be in processing but is")
      assert((not authorizer.ill?), "Should not be ill but is")
    end
  end

  test "checked out holding, user with on shelf and hold permissions" do
    holding = @checked_out_holding
    authorizer = HoldingRequestAuthorizer.new(holding, @user)
    VCR.use_cassette('user aleph permissions') do
      assert(authorizer.recallable?, "Should be recallable but not.")
      assert(authorizer.ill?, "Should be ill but not.")
      assert((not authorizer.available?), "Should not be available but is")
      assert((not authorizer.offsite?), "Should not be offsite but is")
      assert((not authorizer.on_order?), "Should not be on order but is")
      assert((not authorizer.in_processing?), "Should not be in processing but is")
    end
  end

  test "in processing holding, user with on shelf and hold permissions" do
    holding = @in_processing_holding
    authorizer = HoldingRequestAuthorizer.new(holding, @user)
    VCR.use_cassette('user aleph permissions') do
      assert(authorizer.in_processing?, "Should be in processing but not.")
      assert(authorizer.ill?, "Should be ill but not.")
      assert((not authorizer.available?), "Should not be available but is")
      assert((not authorizer.offsite?), "Should not be offsite but is")
      assert((not authorizer.recallable?), "Should not be recallable but is")
      assert((not authorizer.on_order?), "Should not be on order but is")
    end
  end

  test "ill holding, user with on shelf and hold permissions" do
    holding = @ill_holding
    authorizer = HoldingRequestAuthorizer.new(holding, @user)
    VCR.use_cassette('user aleph permissions') do
      assert(authorizer.ill?, "Should be ill but not.")
      assert((not authorizer.available?), "Should not be available but is")
      assert((not authorizer.offsite?), "Should not be offsite but is")
      assert((not authorizer.recallable?), "Should not be recallable but is")
      assert((not authorizer.on_order?), "Should not be on order but is")
      assert((not authorizer.in_processing?), "Should not be in processing but is")
    end
  end

  test "available holding, user without on shelf and with hold permissions" do
    holding = @available_holding
    VCR.use_cassette('user aleph permissions without on shelf') do
      authorizer = HoldingRequestAuthorizer.new(holding, @user)
      assert((not authorizer.available?), "Should not be available but is.")
      assert((not authorizer.offsite?), "Should not be offsite but is")
      assert((not authorizer.recallable?), "Should not be recallable but is")
      assert((not authorizer.on_order?), "Should not be on order but is")
      assert((not authorizer.in_processing?), "Should not be in processing but is")
      assert((not authorizer.ill?), "Should not be ill but is")
    end
  end

  test "offsite holding, user without on shelf and with hold permissions" do
    holding = @offsite_holding
    authorizer = HoldingRequestAuthorizer.new(holding, @user)
    VCR.use_cassette('user aleph permissions without on shelf') do
      assert(authorizer.offsite?, "Should be offsite but not.")
      assert((not authorizer.available?), "Should not be available but is")
      assert((not authorizer.recallable?), "Should not be recallable but is")
      assert((not authorizer.on_order?), "Should not be on order but is")
      assert((not authorizer.in_processing?), "Should not be in processing but is")
      assert((not authorizer.ill?), "Should not be ill but is")
    end
  end

  test "checked out holding, user without on shelf and with hold permissions" do
    holding = @checked_out_holding
    authorizer = HoldingRequestAuthorizer.new(holding, @user)
    VCR.use_cassette('user aleph permissions without on shelf') do
      assert(authorizer.recallable?, "Should be recallable but not.")
      assert(authorizer.ill?, "Should be ill but not.")
      assert((not authorizer.available?), "Should not be available but is")
      assert((not authorizer.offsite?), "Should not be offsite but is")
      assert((not authorizer.on_order?), "Should not be on order but is")
      assert((not authorizer.in_processing?), "Should not be in processing but is")
    end
  end

  test "in processing holding, user without on shelf and with hold permissions" do
    holding = @in_processing_holding
    authorizer = HoldingRequestAuthorizer.new(holding, @user)
    VCR.use_cassette('user aleph permissions without on shelf') do
      assert(authorizer.in_processing?, "Should be in processing but not.")
      assert(authorizer.ill?, "Should be ill but not.")
      assert((not authorizer.available?), "Should not be available but is")
      assert((not authorizer.offsite?), "Should not be offsite but is")
      assert((not authorizer.recallable?), "Should not be recallable but is")
      assert((not authorizer.on_order?), "Should not be on order but is")
    end
  end

  test "ill holding, user without on shelf and with hold permissions" do
    holding = @ill_holding
    authorizer = HoldingRequestAuthorizer.new(holding, @user)
    VCR.use_cassette('user aleph permissions without on shelf') do
      assert(authorizer.ill?, "Should be ill but not.")
      assert((not authorizer.available?), "Should not be available but is")
      assert((not authorizer.offsite?), "Should not be offsite but is")
      assert((not authorizer.recallable?), "Should not be recallable but is")
      assert((not authorizer.on_order?), "Should not be on order but is")
      assert((not authorizer.in_processing?), "Should not be in processing but is")
    end
  end

  test "available holding, user without on shelf or hold permissions" do
    holding = @available_holding
    VCR.use_cassette('user aleph permissions without on shelf or hold') do
      authorizer = HoldingRequestAuthorizer.new(holding, @user)
      assert((not authorizer.available?), "Should not be available but is.")
      assert((not authorizer.offsite?), "Should not be offsite but is")
      assert((not authorizer.recallable?), "Should not be recallable but is")
      assert((not authorizer.on_order?), "Should not be on order but is")
      assert((not authorizer.in_processing?), "Should not be in processing but is")
      assert((not authorizer.ill?), "Should not be ill but is")
    end
  end

  test "offsite holding, user without on shelf or hold permissions" do
    holding = @offsite_holding
    authorizer = HoldingRequestAuthorizer.new(holding, @user)
    VCR.use_cassette('user aleph permissions without on shelf or hold') do
      assert((not authorizer.offsite?), "Should not be offsite but is.")
      assert((not authorizer.available?), "Should not be available but is")
      assert((not authorizer.recallable?), "Should not be recallable but is")
      assert((not authorizer.on_order?), "Should not be on order but is")
      assert((not authorizer.in_processing?), "Should not be in processing but is")
      assert((not authorizer.ill?), "Should not be ill but is")
    end
  end

  test "checked out holding, user without on shelf or hold permissions" do
    holding = @checked_out_holding
    authorizer = HoldingRequestAuthorizer.new(holding, @user)
    VCR.use_cassette('user aleph permissions without on shelf or hold') do
      assert(authorizer.ill?, "Should be ill but not.")
      assert((not authorizer.recallable?), "Should not be recallable but is.")
      assert((not authorizer.available?), "Should not be available but is")
      assert((not authorizer.offsite?), "Should not be offsite but is")
      assert((not authorizer.on_order?), "Should not be on order but is")
      assert((not authorizer.in_processing?), "Should not be in processing but is")
    end
  end

  test "in processing holding, user without on shelf or hold permissions" do
    holding = @in_processing_holding
    authorizer = HoldingRequestAuthorizer.new(holding, @user)
    VCR.use_cassette('user aleph permissions without on shelf or hold') do
      assert(authorizer.ill?, "Should be ill but not.")
      assert((not authorizer.in_processing?), "Should not be in processing but is.")
      assert((not authorizer.available?), "Should not be available but is")
      assert((not authorizer.offsite?), "Should not be offsite but is")
      assert((not authorizer.recallable?), "Should not be recallable but is")
      assert((not authorizer.on_order?), "Should not be on order but is")
    end
  end

  test "ill holding, user without on shelf or hold permissions" do
    holding = @ill_holding
    authorizer = HoldingRequestAuthorizer.new(holding, @user)
    VCR.use_cassette('user aleph permissions without on shelf or hold') do
      assert(authorizer.ill?, "Should be ill but not.")
      assert((not authorizer.available?), "Should not be available but is")
      assert((not authorizer.offsite?), "Should not be offsite but is")
      assert((not authorizer.recallable?), "Should not be recallable but is")
      assert((not authorizer.on_order?), "Should not be on order but is")
      assert((not authorizer.in_processing?), "Should not be in processing but is")
    end
  end
end
