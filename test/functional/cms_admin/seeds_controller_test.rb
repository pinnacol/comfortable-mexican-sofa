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

  def test_get_new
    ComfortableMexicanSofa.configuration.seed_data_path = File.expand_path('../../cms_seeds', File.dirname(__FILE__))
    get :new
    assert_response :success
    assert assigns(:cms_seed)
  end

  def test_get_edit
    ComfortableMexicanSofa.configuration.seed_data_path = File.expand_path('../../cms_seeds', File.dirname(__FILE__))
    get :edit, :id => "test|host"
    assert_response :success
    assert assigns(:cms_seed)
  end

  def test_get_edit_failure
    get :edit, :id => 'not_found'
    assert_response :redirect
    assert_redirected_to :action => :index
    assert_equal 'Seed not found', flash[:error]
  end

  def test_download_seed
    ComfortableMexicanSofa.configuration.seed_data_path = File.expand_path('../../cms_seeds', File.dirname(__FILE__))
    get :download, :id => "test|host"
    assert_response :success
    assert assigns(:cms_seed)
  end

  # def test_destroy_seed
  #   ComfortableMexicanSofa.configuration.seed_data_path = File.expand_path('../../cms_seeds', File.dirname(__FILE__))
  #   delete :destroy, :id => "test|functional|create"
  #   assert_redirected_to :action => :index
  #   assert_equal 'Seed deleted', flash[:notice]
  # end
end
