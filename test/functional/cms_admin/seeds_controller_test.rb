require File.expand_path('../../test_helper', File.dirname(__FILE__))

class CmsAdmin::SeedsControllerTest < ActionController::TestCase
  def test_get_index
    ComfortableMexicanSofa.configuration.seed_data_path = File.expand_path('../../cms_seeds', File.dirname(__FILE__))
    get :index
    assert_response :success
    assert assigns(:cms_seeds)
    assert_template :index
  end

  def test_get_index_with_no_pages
    ComfortableMexicanSofa.configuration.seed_data_path = nil
    get :index
    assert_response :redirect
  end

  def test_download_seed
    ComfortableMexicanSofa.configuration.seed_data_path = File.expand_path('../../cms_seeds', File.dirname(__FILE__))
    get :download, :id => "test|host"
    assert_response :success
    assert assigns(:cms_seed)
  end
end
