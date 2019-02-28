class Resource
  include ActiveModel::Model
  attr_reader :sitepress
  delegate :request_path, :body, :data, to: :sitepress

  validate :validated_wellformed_asset

  def initialize(sitepress)
    @sitepress = sitepress
  end

  def to_param
    CGI.escape request_path
  end

  def persisted?
    asset.exists?
  end

  def source
    @_source ||= File.read asset.path
  end

  def source=(source)
    @_source = source
  end

  def save
    File.write file_path, source if valid?
  end

  def file_path
    asset.path
  end

  private
    def asset
      sitepress.asset
    end

    # Just try parsing it, blurg, this sucks, but it will do for now.
    def validated_wellformed_asset
      parser = Sitepress::Frontmatter.new(source)
      errors.add(:source, "frontmatter is not a hash") unless parser.data.is_a? Hash
      errors.add(:source, "body is empty") if parser.body.empty?
    rescue Psych::SyntaxError => e
      errors.add(:source, e.message)
    end
end
