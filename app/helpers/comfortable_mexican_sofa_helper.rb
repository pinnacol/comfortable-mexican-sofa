# Need uniquely named helper module to allow mixin to host app, which must manually include it
# See engine.rb where this is mixed in explicitly

module ComfortableMexicanSofaHelper
  def seed_manager_enabled?
    File.directory?(ComfortableMexicanSofa.config.seed_data_path.to_s)
  end
end
