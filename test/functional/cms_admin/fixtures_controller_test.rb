require File.expand_path('../../test_helper', File.dirname(__FILE__))

class CmsAdmin::FixturesControllerTest < ActionController::TestCase
  def setup
    super
    @model = Cms::Fixture.new(:name => cms_sites(:default).hostname)
    ComfortableMexicanSofa::Fixtures.export_all(cms_sites(:default).hostname)
  end

  def test_get_index
    get :index
    assert_response :success
    assert assigns(:fixtures)
    assert_template :index
  end

  def test_get_new
    get :new
    assert_response :success
    assert assigns(:fixture)
    assert_template :new
    assert_select 'form[action=/cms-admin/fixtures]'
  end

  def test_destroy
    assert_difference 'Cms::Fixture.count', -1 do
      delete :destroy, :id => @model.to_key
      assert_response :redirect
      assert_redirected_to :action => :index
      assert_equal 'Fixture deleted', flash[:notice]
    end
  end
end
