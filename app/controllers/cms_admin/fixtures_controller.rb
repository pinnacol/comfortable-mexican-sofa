class CmsAdmin::FixturesController < CmsAdmin::BaseController

  skip_before_filter  :load_admin_site,
                      :load_fixtures

  before_filter :load_fixture,   :only => [:show, :destroy, :import]

  def index
    @fixtures = Cms::Fixture.all
  end

  def new
    @fixture  = Cms::Fixture.new
  end

  def destroy
    @fixture.destroy
    flash[:notice] = I18n.t('cms.fixtures.deleted')
    redirect_to :action => :index
  end

  def import
    if request.put? && @fixture.import(params[:fixture][:name])
      flash[:notice] = I18n.t('cms.fixtures.imported')
      redirect_to :action => :index
    elsif request.get?
      render :action => :import
    else
      redirect_to :action => :index
    end
  end

protected
  def load_fixture
    @fixture = Cms::Fixture.find(params[:id])
  rescue
    flash[:error] = I18n.t('cms.fixtures.not_found')
    redirect_to :action => :index
  end
end
