require File.expand_path('../../test_helper', File.dirname(__FILE__))

class CmsAdmin::SeedsControllerTest < ActionController::TestCase
  def cms_seeds(key)
    { 
      :default => CmsSeed.new({ :name => "default.host" })
    }[key]
  end

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

  def test_create_with_commit
    seed = cms_seeds(:default)
    assert_difference 'CmsSeed.count' do
      post :create, :cms_seed => {
        :name     => 'test.create'
      }, :commit  => 'Create Snippet'
      assert_response :redirect
      assert_redirected_to :action => :index
      assert_equal 'Seed created', flash[:notice]
    end
  end

  def test_create_without_commit
    seed = cms_seeds(:default)
    assert_difference 'CmsSnippet.count' do
      post :create, :cms_seed => {
        :name     => 'default.host'
      }
      assert_response :redirect
      assert_redirected_to :action => :edit, :id => seed
      assert_equal 'Seed created', flash[:notice]
    end
  end

  def test_creation_failure
    seed = cms_seeds(:default)
    assert_no_difference 'CmsSeed.count' do
      post :create, :cms_snippet => { }
      assert_response :success
      assert_template :new
      assert_equal 'Failed to create seed', flash[:error]
    end
  end

  def test_update_with_commit
    seed = cms_seeds(:default)
    put :update, :id => seed.id, :cms_seed => {
      :name    => 'New-Seed'
    }, :commit  => 'Update Seed'
    assert_response :redirect
    assert_redirected_to :action => :index
    assert_equal 'Seed updated', flash[:notice]
    seed.reload
    assert_equal 'New-Seed', seed.name
  end

  def test_update_without_commit
    seed = cms_seeds(:default)
    put :update, :id => seed.id, :cms_seed => {
      :name    => 'New-Seed'
    }
    assert_response :redirect
    assert_redirected_to :action => :edit, :id => seed
    assert_equal 'Seed updated', flash[:notice]
    seed.reload
    assert_equal 'New-Seed', seed.name
  end

  def test_update_failure
    seed = cms_seeds(:default)
    put :update, :id => seed.id, :cms_snippet => {
      :name => ''
    }
    assert_response :success
    assert_template :edit
    seed.reload
    assert_not_equal '', seed.name
    assert_equal 'Failed to update seed', flash[:error]
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
