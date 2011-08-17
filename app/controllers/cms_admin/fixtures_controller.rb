class CmsAdmin::FixturesController < CmsAdmin::BaseController

  skip_before_filter  :load_admin_site,
                      :load_fixtures

  def index
    @fixtures = Cms::Fixture.all
  end

  def new
    @fixture  = Cms::Fixture.new
  end

  def destroy
    @fixture = Cms::Fixture.find(params[:id])
    @fixture.destroy
    flash[:notice] = I18n.t('cms.fixtures.deleted')
    redirect_to :action => :index
  end
end
