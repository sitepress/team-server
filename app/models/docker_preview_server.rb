class DockerPreviewServer < ApplicationRecord
  belongs_to :website

  # Root web server path
  DEFAULT_ROOT_PATH = Pathname.new("/").freeze

  # Preview server host
  DEFAULT_HOST = "0.0.0.0".freeze

  # Preview server scheme
  DEFAULT_SCHEME = "http".freeze

  # Prevents collisions with other docker images
  DEFAULT_CONTAINER_PREFIX = "editor_preview_server".freeze

  delegate :start, :stop, :restart, :kill, to: :container

  # Tries to find or create the container in Docker
  def container
    @_container ||= begin
      Docker::Container.get(docker_container_name)
    rescue Docker::Error::NotFoundError
      Docker::Container.create(name: docker_container_name, **docker_config)
    end
  end

  def info
    container.json
  end

  def docker_container_name
    [DEFAULT_CONTAINER_PREFIX, image_name].join("_")
  end

  def preview_url(file_path_param = nil)
    URI.parse("#{DEFAULT_SCHEME}://#{DEFAULT_HOST}:#{host_port}").tap do |url|
      if file_path_param
        preview_file_path = Pathname.new CGI.unescape file_path_param
        relative_path = preview_file_path.relative_path_from(host_volume_path)
        # Remove extensions, etc.
        no_extensions_path = relative_path.basename(relative_path.extname)
        absolute_path = DEFAULT_ROOT_PATH.join(no_extensions_path)
        url.path = absolute_path.to_s
      end
    end
  end

  private
    def host_volume_path
      website.file_path
    end

    def docker_config
      host_volume = website.file_path

      {
        "Cmd": Shellwords.split(container_cmd),
        "Image": image_name,
        "ExposedPorts": {
          "#{container_port}/tcp" => {}
        },
        "HostConfig": {
          "Binds": [
            [host_volume, container_volume_path].join(":")
          ],
          "PortBindings": {
            "#{container_port}/tcp": [
              {
                "HostPort": host_port.to_s
              }
            ]
          }
        }
      }
    end
end
