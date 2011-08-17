require File.expand_path('../../test_helper', File.dirname(__FILE__))

class FixtureTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  def setup
    super
    @model = Cms::Fixture.new(:name => "example.com", :path => Rails.root.join(ComfortableMexicanSofa.config.fixtures_path))
    ComfortableMexicanSofa::Fixtures.export_all(cms_sites(:default).hostname)
  end

  def test_all
    assert_respond_to Cms::Fixture, :all
    assert_kind_of Array, Cms::Fixture.all
  end

  def test_find
    assert_respond_to Cms::Fixture, :find
    fixture = Cms::Fixture.find("test,host")
    assert cms_sites(:default).hostname, fixture.name
    assert File.directory?(fixture.path)
  end

  def test_count
    assert_respond_to Cms::Fixture, :count
    assert_kind_of Integer, Cms::Fixture.count
  end

  def test_persisted?
    assert model.persisted?
    model.path = ""
    assert !model.persisted?
  end

  def test_to_param
    assert "example,com", model.to_key
  end
end
