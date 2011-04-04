require File.expand_path('../test_helper', File.dirname(__FILE__))

class CmsSeedTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  def setup
    @model = CmsSeed.new
  end

  def test_seed_root_path_is_config_seed_path
    assert ComfortableMexicanSofa.configuration.seed_data_path.to_s, CmsSeed.root_path.to_s
  end

  def test_all
    ComfortableMexicanSofa.configuration.seed_data_path = File.expand_path('../cms_seeds', File.dirname(__FILE__))
    seeds = CmsSeed.all
    assert_equal 1, seeds.size
    assert "test.local", seeds.first.name
  end

  def test_id
    seed = CmsSeed.new(:name => 'test.host', :path => '')
    assert "test|local", seed.id
  end

  def test_find
    ComfortableMexicanSofa.configuration.seed_data_path = File.expand_path('../cms_seeds', File.dirname(__FILE__))
    seed = CmsSeed.find("test.host")
    assert seed.is_a?(CmsSeed)
    assert "test.host", seed.name
  end

  def test_find_bogus
    ComfortableMexicanSofa.configuration.seed_data_path = File.expand_path('../cms_seeds', File.dirname(__FILE__))
    assert_nil CmsSeed.find("test.bogus")
  end

  def test_from_param
    ComfortableMexicanSofa.configuration.seed_data_path = File.expand_path('../cms_seeds', File.dirname(__FILE__))
    seed = CmsSeed.from_param("test|host")
    assert seed.is_a?(CmsSeed)
    assert "test.host", seed.name
  end

  def test_path
    ComfortableMexicanSofa.configuration.seed_data_path = File.expand_path('../cms_seeds', File.dirname(__FILE__))
    seed = CmsSeed.find("test.host")
    assert seed.path.is_a?(Pathname)
  end

  def test_zip_file_name
    ComfortableMexicanSofa.configuration.seed_data_path = File.expand_path('../cms_seeds', File.dirname(__FILE__))
    seed = CmsSeed.find("test.host")
    assert "test.host.zip", seed.zip_file_name
  end

  def test_to_zip_io
    ComfortableMexicanSofa.configuration.seed_data_path = File.expand_path('../cms_seeds', File.dirname(__FILE__))
    seed  = CmsSeed.find("test.host")
    file  = seed.to_zip_io

    assert file.is_a?(Tempfile)
    assert file.respond_to?(:read)
    seed.zip_cleanup
  end
end
