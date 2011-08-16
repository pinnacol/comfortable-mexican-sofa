class Cms::Fixture
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :name, :path, :file
  attr_reader   :errors

  def self.all
    Pathname.new(ComfortableMexicanSofa.config.fixtures_path).children.collect do |c|
      new(:name => c.basename.to_s, :path => c)
    end
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
    @errors = ActiveModel::Errors.new(self)
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
    !path.nil?
  end

  def read_attribute_for_validation(attr)
    send(attr)
  end

  def to_key
    persisted? ? [name.gsub('.', '-')] : nil
  end

  def to_s
    name
  end

  def valid?
    true
  end
end
