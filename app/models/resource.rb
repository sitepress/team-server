class Resource
  include ActiveModel::Model

  delegate :request_path, :body, :data, to: :sitepress

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
    File.write file_path, source
  end

  def file_path
    asset.path
  end

  def sitepress
    @sitepress
  end

  private
    def asset
      sitepress.asset
    end
end
