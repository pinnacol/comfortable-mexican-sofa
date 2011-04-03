require File.expand_path('../test_helper', File.dirname(__FILE__))

class SeedManagerTest < ActionDispatch::IntegrationTest
  def test_seed_manager_admin_link_not_rendering
    http_auth :get, cms_admin_sites_path
    assert_response :success
    assert_no_match /Seeds/, response.body
  end

  def test_seed_manager_admin_link_is_rendering
    ComfortableMexicanSofa.configuration.seed_data_path = File.expand_path('../cms_seeds', File.dirname(__FILE__))

    http_auth :get, cms_admin_sites_path
    assert_response :success
    assert_match /Seeds/, response.body
  end

  def test_seed_manager_admin_link_not_rendering_when_invalid_path
    ComfortableMexicanSofa.configuration.seed_data_path = File.expand_path('../bogus', File.dirname(__FILE__))

    http_auth :get, cms_admin_sites_path
    assert_response :success
    assert_no_match /Seeds/, response.body
  end
end
