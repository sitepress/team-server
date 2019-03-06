class DockerPreviewServer < ApplicationRecord
  belongs_to :website

  # Preview server host
  DEFAULT_HOST = "0.0.0.0".freeze

  # Preview server scheme
  DEFAULT_SCHEME = "http".freeze

  # Prevents collisions with other docker images
  DEFAULT_CONTAINER_PREFIX = "editor_preview_server".freeze

  # Root web server path.
  DEFAULT_ROOT_REQUEST_PATH = Pathname.new("/").freeze

  delegate :start, :stop, :restart, :kill, to: :container

  after_commit :build_container

  # Tries to find or create the container in Docker
  def container
    @_container ||= begin
      Docker::Container.get(docker_container_name)
    rescue Docker::Error::NotFoundError
      build_container
    end
  end

  def build_container
    Docker::Container.create(name: docker_container_name, **docker_config)
  end

  def info
    container.json
  end

  def docker_container_name
    [DEFAULT_CONTAINER_PREFIX, image_name, updated_at.to_i].join("_")
  end

  def preview_url(file_path_param = nil)
    resource = website.find_resource_by_id file_path_param

    URI.parse("#{DEFAULT_SCHEME}://#{DEFAULT_HOST}:#{host_port}").tap do |url|
      url.path = root_request_path(remove_extensions(resource.request_path)).to_s
    end
  end

  def root_request_path(request_path = "")
    DEFAULT_ROOT_REQUEST_PATH.join request_path
  end

  private
    # TODO: This will vary by site. probably need to extract file_path to request_path mapping into
    # a class that a user can choose from the UI. Its also worth looking at the default glob in website
    # to see if that should be rolled into this class as well.
    def default_path_processor(path)
      # Remove extensions, etc.
      no_extensions_path = relative_path.basename(relative_path.extname)
      absolute_path = DEFAULT_ROOT_PATH.join(no_extensions_path)
    end

    def remove_extensions(path)
      path, file = path.split
      ext = file.to_s.scan(/\..+$/).first
      path.join file.basename(ext)
    end

    def host_volume_path
      website.file_path
    end

    def docker_config
      {
        "Cmd": Shellwords.split(container_cmd),
        "Image": image_name,
        "ExposedPorts": {
          "#{container_port}/tcp" => {}
        },
        "HostConfig": {
          "Binds": [
            [host_volume_path, container_volume_path].join(":")
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
