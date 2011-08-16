class Cms::Fixture
  def self.all
    Pathname.new(ComfortableMexicanSofa.config.fixtures_path).children.collect do |c|
      new(c)
    end
  end

  def initialize(path)

  end
end
