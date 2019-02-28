class Resource
  include ActiveModel::Model

  delegate :request_path, :body, :data, to: :sitepress_resource

  def initialize(sitepress_resource)
    @sitepress_resource = sitepress_resource
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
    File.write asset.path, source
  end

  private
    def sitepress_resource
      @sitepress_resource
    end

    def asset
      sitepress_resource.asset
    end
end