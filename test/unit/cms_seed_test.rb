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
    assert_exception_raised CmsSeed::SeedNotFound do
      CmsSeed.find("test.bogus")
    end
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

  def test_count
    assert_equal 2, CmsSeed.count
  end

  # def test_destroy
  #   ComfortableMexicanSofa.configuration.seed_data_path = File.expand_path('../cms_seeds', File.dirname(__FILE__))
  #   assert_difference 'CmsSeed.count', -1 do
  #     seed = CmsSeed.find("test.model.create")
  #     seed.destroy
  #   end
  # end
end
