require File.expand_path('../test_helper', File.dirname(__FILE__))

class CmsSeedTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  def setup
    super
    ComfortableMexicanSofa.configuration.seed_data_path = File.expand_path('../cms_seeds', File.dirname(__FILE__))
    @model = CmsSeed.new
  end

  def test_seed_root_path_is_config_seed_path
    assert ComfortableMexicanSofa.configuration.seed_data_path.to_s, CmsSeed.root_path.to_s
  end

  def test_all
    seeds = CmsSeed.all
    assert "test.local", seeds.first.name
  end

  def test_id
    seed = cms_seeds(:test)
    assert "test|local", seed.id
  end

  def test_find
    seed = cms_seeds(:test)
    assert seed.is_a?(CmsSeed)
    assert "test.host", seed.name
  end

  def test_find_bogus
    assert_exception_raised CmsSeed::SeedNotFound do
      CmsSeed.find("test.bogus")
    end
  end

  def test_from_param
    seed = CmsSeed.from_param("test|host")
    assert seed.is_a?(CmsSeed)
    assert "test.host", seed.name
  end

  def test_path
    seed = cms_seeds(:test)
    assert seed.path.is_a?(Pathname)
    assert_equal ComfortableMexicanSofa.configuration.seed_data_path + "/test.host", seed.path.to_s
    assert_equal "test.host", seed.path.basename.to_s
  end

  def test_zip_file_name
    seed = cms_seeds(:test)
    assert "test.host.zip", seed.zip_file_name
  end

  def test_to_zip_io
    seed = cms_seeds(:test)
    file  = seed.to_zip_io

    assert file.is_a?(Tempfile)
    assert file.respond_to?(:read)
    seed.zip_cleanup
  end

  def test_create
    assert_difference 'CmsSeed.count' do
      seed = CmsSeed.new(
        :name     => "test.host.create",
        :zip_file => fixture_file_upload('files/test.host.zip')
      )
      assert seed.save
    end
  end

  def test_create_without_zip
    assert_no_difference 'CmsSeed.count' do
      seed = CmsSeed.new(:name => "test.host.create")
      assert !seed.save
      assert seed.errors.present?
      assert_has_errors_on seed, [:zip_file]
    end
  end

  def test_create_with_taken_path
    assert_no_difference 'CmsSeed.count' do
      seed = CmsSeed.new(:name => "test.host")
      assert !seed.save
      assert seed.errors.present?
      assert_has_errors_on seed, [:name]
      assert_match /exists/, seed.errors[:name].to_s
    end
  end

  def test_update_with_taken_path
    seed = cms_seeds(:default)
    assert_exception_raised CmsSeed::RecordInvalid do
      seed.update_attributes!(:name => "test.host")
    end
  end

  def test_destroy
    assert_difference 'CmsSeed.count', -1 do
      seed = CmsSeed.find("test.host.create")
      seed.destroy
    end
  end

  def test_associated_site
    seed = cms_seeds(:default)
    seed.site_id = cms_sites(:default).id
    assert_equal cms_sites(:default), seed.site
  end
end
