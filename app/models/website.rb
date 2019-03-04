class Website < ApplicationRecord
  has_one :docker_preview_server
  delegate :preview_url, to: :docker_preview_server

  def resources
    Enumerator.new do |y|
      files.each do |path|
        y << Resource.new(path) if File.file? path
      end
    end
  end

  def find_resource_by_id(file_path_param)
    # TODO: Need to make sure this path can't go
    # beyond the root set by the website!
    raise SecurityError unless Rails.env.development?

    file_path = CGI.unescape file_path_param

    Resource.new(file_path).tap do |r|
      raise ActiveRecord::NotFoundError unless r.persisted?
    end
  end

  private
    def files
      Dir.glob(Pathname.new(file_path).join("**/*.html*"))
    end
end
