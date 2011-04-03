require 'active_model'

class CmsSeed
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Serialization
  include ActiveModel::Conversion

  class UnknownAttributeError < NoMethodError; end

  attr_accessor :name

  validates_presence_of :name

  def self.all(path = ComfortableMexicanSofa.configuration.seed_data_path)
    seeds = []
    begin
      Dir.entries(path.to_s).each do |path|
        seeds << new(:name => path)
      end
    ensure
      return seeds
    end
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

  def persisted?
    false
  end
end
