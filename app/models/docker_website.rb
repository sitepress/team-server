class DockerWebsite
  ROOT_NAMESPACE = "editor"

  attr_reader :website
  delegate :start, :stop, :restart, :kill, to: :container

  def initialize(website)
    @website = website
  end

  def container
    # TODO: Name a docker repo and have a `find_or_create_container`
    # method that tries to make this act more like a singleton, so that
    # we have only one instance running at a time.
    @_container ||= Docker::Container.get(docker_container_name) || Docker::Container.create(name: docker_container_name, **docker_config)
  end

  def info
    container.json
  end

  def docker_container_name
    [ROOT_NAMESPACE, website.docker_image_name].join("_")
  end

  private
    def docker_config
      host_volume = website.file_path
      cmd = website.docker_container_cmd
      container_port = website.docker_container_port.to_s
      host_port = website.docker_host_port.to_s
      image_name = website.docker_image_name
      container_volume = website.docker_container_volume_file_path

      {
        "Cmd": Shellwords.split(cmd),
        "Image": image_name,
        "ExposedPorts": {
          "#{container_port}/tcp" => {}
        },
        "HostConfig": {
          "Binds": [
            [host_volume, container_volume].join(":")
          ],
          "PortBindings": {
            "#{container_port}/tcp": [
              {
                "HostPort": host_port
              }
            ]
          }
        }
      }
    end
end
