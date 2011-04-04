class CmsAdmin::SeedsController < CmsAdmin::BaseController

  before_filter :build_cms_seed, :only => [:new, :create]
  before_filter :load_cms_seed,  :only => [:edit, :update, :destroy, :download]

  def index
    if ComfortableMexicanSofa.configuration.seed_data_path
      @cms_seeds = CmsSeed.all
      if @cms_seeds.empty?
        redirect_to new_cms_admin_seed_path
      end
    else
      redirect_to ComfortableMexicanSofa.configuration.admin_route_redirect
    end
  end

  def new
  end

  def create
    @cms_seed.save!
    flash[:notice] = 'Seed created'
    redirect_to (params[:commit] ? {:action => :index} : {:action => :edit, :id => @cms_seed})
  rescue CmsSeed::RecordInvalid
    flash.now[:error] = 'Failed to create seed'
    render :action => :new
  end

  def edit
  end

  def update
    @cms_seed.update_attributes!(params[:cms_seed])
    flash[:notice] = 'Seed updated'
    redirect_to (params[:commit] ? {:action => :index} : {:action => :edit, :id => @cms_seed})
  rescue CmsSeed::RecordInvalid
    flash.now[:error] = 'Failed to update seed'
    render :action => :edit
  end

  def destroy
    @cms_seed.destroy
    flash[:notice] = 'Seed deleted'
    redirect_to :action => :index
  end

  def download
    send_data(@cms_seed.to_zip_io.read, :filename => @cms_seed.zip_file_name, :type => "application/zip")
    @cms_seed.zip_cleanup
  end

protected

  def build_cms_seed
    @cms_seed = CmsSeed.new(params[:cms_seed])
  end

  def load_cms_seed
    @cms_seed = CmsSeed.from_param(params[:id])
  rescue CmsSeed::SeedNotFound
    flash[:error] = 'Seed not found'
    redirect_to :action => :index
  end
end
