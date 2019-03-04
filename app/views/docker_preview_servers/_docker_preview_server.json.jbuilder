json.extract! docker_preview_server, :id, :website_id, :image_name, :container_cmd, :container_volume_path, :container_port, :host_port, :created_at, :updated_at
json.url docker_preview_server_url(docker_preview_server, format: :json)
