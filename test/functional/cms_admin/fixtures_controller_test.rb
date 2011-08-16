require File.expand_path('../../test_helper', File.dirname(__FILE__))

class CmsAdmin::FixturesControllerTest < ActionController::TestCase
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
end
