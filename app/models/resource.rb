class Resource
  include ActiveModel::Model
  attr_reader :file_path, :website

  validate :validated_wellformed_asset

  def initialize(file_path: , website:)
    @file_path = Pathname.new(file_path)
    @website = website
  end

  def to_param
    CGI.escape file_path.to_s
  end

  def persisted?
    file_path.exist?
  end

  def source
    @_source ||= File.read file_path
  end

  def source=(source)
    @_source = source
  end

  def save
    File.write file_path, source if valid?
  end

  def request_path
    file_path.relative_path_from(website.file_path)
  end

  private
    # Just try parsing it, blurg, this sucks, but it will do for now.
    def validated_wellformed_asset
      parser = Sitepress::Frontmatter.new(source)
      errors.add(:source, "frontmatter is not a hash") unless parser.data.is_a? Hash
      errors.add(:source, "body is empty") if parser.body.empty?
    rescue Psych::SyntaxError => e
      errors.add(:source, e.message)
    end
end
