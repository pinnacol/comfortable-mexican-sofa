class CmsAdmin::SeedsController < CmsAdmin::BaseController
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

  def download
    @cms_seed = CmsSeed.from_param(params[:id])
    send_data(@cms_seed.to_zip_io.read, :filename => @cms_seed.zip_file_name, :type => "application/zip")
    @cms_seed.zip_cleanup
  end
end
