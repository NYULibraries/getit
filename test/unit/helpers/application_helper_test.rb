require 'test_helper'
require 'institutions'
class ApplicationHelperTest < ActionView::TestCase
  attr_reader :current_primary_institution

  setup do
    @current_primary_institution ||= Institutions.institutions[:NYU]
  end

  test "should return ILL URL for NYU" do
    assert_equal "http://ill.library.nyu.edu", ill_url
  end
end
