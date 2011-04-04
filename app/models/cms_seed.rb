require 'active_model'
require 'find'
require 'zip/zip'

class CmsSeed
  extend ActiveModel::Naming
  extend ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Serialization
  include ActiveModel::Conversion

  class CmsSeedError          < StandardError; end
  class UnknownAttributeError < NoMethodError; end
  class SeedNotFound          < CmsSeedError; end
  class RecordInvalid         < CmsSeedError; end
  class RecordInvalid         < CmsSeedError
    attr_reader :record
    def initialize(record)
      @record = record
      errors = @record.errors.full_messages.join(", ")
    end
  end

  attr_accessor   :name, :site_id, :zip_file
  attr_accessor   :exporting, :uploading

  validates_presence_of :name
  validates_presence_of :site_id,     :if => :exporting?
  validates_presence_of :zip_file,    :if => :uploading?
  validate              :is_zip_file, :if => :uploading?
  validate              :uniqueness_of_path

  def self.all
    begin
      seeds = []
      root_path.children.each do |dir|
        seeds << new(:name => dir.basename) if dir.directory?
      end
    ensure
      return seeds
    end
  end

  def self.count
    all.size
  end

  def self.find(name)
    dir = root_path.join(name)
    if dir.directory?
      new(:name => dir.basename.to_s)
    else
      raise SeedNotFound
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
    @new_record     = !(self.path.directory? && self.path.to_s != self.class.root_path.to_s)
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

  def destroy
    path.rmtree
  end

  def exporting?
    @exporting || false
  end

  def id
    new_record? ? nil : name.to_s.sub('.', '|')
  end

  def new_record?
    @new_record
  end

  def path
    self.class.root_path.join(self.name.to_s)
  end

  def persisted?
    !new_record?
  end

  def relative_path
    path.to_s.sub(Rails.root.to_s + '/', '')
  end

  def reload
    self.class.from_param(self)
  end

  def save
    if valid?
      export_site if exporting?
      unzip_seed  if uploading?
    end

    errors.empty?
  end

  def save!
    save ? self : raise(RecordInvalid.new(self))
  end

  def to_zip_io
    @zipfile = Tempfile.new([name, ".zip"])
    Zip::ZipOutputStream.open(@zipfile.path) do |zip|
      Find.find(path.to_s) do |item|
        next if File.directory?(item)
        file = item.sub(path.to_s + "/", "")
        zip.put_next_entry(file)
        zip.write(IO.read(item))
      end
    end

    @zipfile
  end

  def update_attributes!(attributes)
    if valid?
    else
      raise RecordInvalid.new(self)
    end
  end

  def uploading?
    @uploading || true
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

private
  def export_site
    $stderr.puts(" => Exporting site...")
  end

  def is_zip_file
    if zip_file.present? && zip_file.original_filename !~ /\.zip$/
      errors.add(:zip_file, "must be a zip file")
    end
  end

  def uniqueness_of_path
    if path.directory?
      errors.add(:name, "already exists")
    end
  end

  def unzip_seed
    uploaded_file = zip_file.respond_to?(:path) ? zip_file : zip_file.tempfile
    Zip::ZipFile.open(uploaded_file.path) do |zip|
      zip.each do |file|
        final_path = path.join(file.name)
        FileUtils.mkdir_p(File.dirname(final_path))
        zip.extract(file, final_path) unless File.exists?(final_path)
      end
    end
  end
end
