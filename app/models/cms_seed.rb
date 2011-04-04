require 'active_model'
require 'find'
require 'zip/zip'

class CmsSeed
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Serialization
  include ActiveModel::Conversion

  class UnknownAttributeError < NoMethodError; end

  attr_accessor   :name, :path

  validates_presence_of :name, :path

  def self.all
    begin
      seeds = []
      root_path.children.each do |dir|
        seeds << new(:name => dir.basename, :path => dir) if dir.directory?
      end
    ensure
      return seeds
    end
  end

  def self.find(name)
    dir = root_path.join(name)
    if dir.directory?
      new(:name => dir.basename.to_s, :path => dir)
    else
      nil
    end
  end

  def self.from_param(param)
    find(param.sub("|", "."))
  end

  def self.root_path
    Pathname(ComfortableMexicanSofa.configuration.seed_data_path.to_s)
  end

  def initialize(attributes = nil)
    self.attributes = attributes unless attributes.nil?
  end

  def attributes=(new_attributes)
    return unless new_attributes.is_a?(Hash)
    attributes = new_attributes.stringify_keys

    attributes.each do |key, value|
      if respond_to?(:"#{key}=")
        send(:"#{key}=", value)
      else
        raise(UnknownAttributeError, "unknown attribute: #{key}")
      end
    end
  end

  def id
    name.to_s.sub('.', '|')
  end

  def persisted?
    true
  end

  def to_zip_io
    @zipfile = Tempfile.new([name, ".zip"])
    Zip::ZipOutputStream.open(@zipfile.path) do |zip|
      Find.find(path.to_s) do |item|
        next if File.directory?(item)
        file = item.sub(path.join("..").to_s + "/", "")
        zip.put_next_entry(file)
        zip.write(IO.read(item))
      end
    end

    @zipfile
  end

  def zip_cleanup
    if @zipfile
      @zipfile.close
      @zipfile.unlink
    end
  end

  def zip_file_name
    "#{name}.zip"
  end
end
