require File.expand_path('../test_helper', File.dirname(__FILE__))

class FixtureTest < ActiveSupport::TestCase
  def test_all
    assert_respond_to Cms::Fixture, :all
    assert_kind_of Array, Cms::Fixture.all
  end
end
