class Cms::Fixture
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::AttributeMethods
  include ActiveModel::Conversion
  include ActiveModel::Validations

  cattr_accessor      :root_path
  define_attr_method  :root_path do
    Pathname.new(ComfortableMexicanSofa.config.fixtures_path)
  end

  attr_accessor :name, :path, :file
  attr_reader   :errors

  def self.all
    root_path.children.collect do |c|
      new(:name => c.basename.to_s, :path => c)
    end
  end

  def self.count
    all.count
  end

  def self.find(id)
    id = from_url(id)
    all.find(nil) { |f| f.name == id }
  end

  def self.human_attribute_name(attr, options = {})
    attr
  end

  def self.lookup_ancestors
    [self]
  end

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value) if respond_to?(name)
    end
    if self.path.blank? && self.name.present? && self.class.root_path.join(self.name).directory?
      self.path = self.class.root_path.join(self.name)
    end
    @errors = ActiveModel::Errors.new(self)
  end

  def import(to_hostname)
    begin
      ComfortableMexicanSofa::Fixtures.import_all(to_hostname, name)
    rescue => error
      Rails.logger.error(error.to_s)
      return false
    end
    return true
  end

  def destroy
    path.rmtree
  end

  def destroyed?
    true
  end

  def i18n_scope
    :activerecord
  end

  def new_record?
    !persisted?
  end

  def persisted?
    path.blank? ? false : File.directory?(path)
  end

  def read_attribute_for_validation(attr)
    send(attr)
  end

  def to_key
    persisted? ? [for_url(name)] : nil
  end

  def to_s
    name
  end

  def valid?
    true
  end

private
  def self.for_url(string)
    string.to_s.gsub('.', ',')
  end

  def self.from_url(string)
    string.to_s.gsub(',', '.')
  end

  def for_url(string)
    self.class.for_url(string)
  end

  def from_url(string)
    self.class.from_url(string)
  end
end
