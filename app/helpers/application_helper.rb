module ApplicationHelper
  def seed_manager_enabled?
    File.directory?(ComfortableMexicanSofa.config.seed_data_path.to_s)
  end
end