class CmsAdmin::FixturesController < CmsAdmin::BaseController

  skip_before_filter  :load_admin_site,
                      :load_fixtures

  def index
    @fixtures = Cms::Fixture.all
  end
end
