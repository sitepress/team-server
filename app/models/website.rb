class Website < ApplicationRecord
  has_one :docker_preview_server
  delegate :preview_url, to: :docker_preview_server

  # Users may only edit files like `*.html.haml`, `*.html.md`, etc.
  DEFAULT_GLOB = "**/*.html*".freeze

  def resources
    Enumerator.new do |y|
      file_paths.each do |path|
        y << build_resource(path) if File.file? path
      end
    end
  end

  def find_resource_by_id(file_path_param)
    # TODO: Need to make sure this path can't go
    # beyond the root set by the website!
    raise SecurityError unless Rails.env.development?

    path = CGI.unescape file_path_param

    build_resource(path).tap do |r|
      raise ActiveRecord::NotFoundError unless r.persisted?
    end
  end

  private
    def build_resource(path)
      Resource.new(file_path: path, website: self)
    end

    def file_paths
      Dir.glob(Pathname.new(file_path).join(DEFAULT_GLOB))
    end
end
