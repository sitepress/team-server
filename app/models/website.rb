class Website < ApplicationRecord
  # Root web server path
  PREVIEW_SERVER_ROOT_PATH = Pathname.new("/").freeze

  # Preview server host
  PREVIEW_SERVER_HOST = "0.0.0.0".freeze

  # Preview server scheme
  PREVIEW_SERVER_SCHEME = "http".freeze

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

  def preview_url(file_path_param = nil)
    URI.parse("#{PREVIEW_SERVER_SCHEME}://#{PREVIEW_SERVER_HOST}:#{docker_host_port}").tap do |url|
      if file_path_param
        preview_file_path = Pathname.new CGI.unescape file_path_param
        relative_path = preview_file_path.relative_path_from(file_path)
        # Remove extensions, etc.
        no_extensions_path = relative_path.basename(relative_path.extname)
        absolute_path = PREVIEW_SERVER_ROOT_PATH.join(no_extensions_path)

        url.path = absolute_path.to_s
      end
    end
  end

  def docker
    @_docker_website ||= DockerWebsite.new(self)
  end

  private
    def files
      Dir.glob(Pathname.new(file_path).join("**/*.html*"))
    end
end
