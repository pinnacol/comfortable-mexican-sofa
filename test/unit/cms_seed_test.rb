require File.expand_path('../test_helper', File.dirname(__FILE__))

class CmsSeedTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  def setup
    @model = CmsSeed.new
  end

  def test_find_all
    
  end
end
