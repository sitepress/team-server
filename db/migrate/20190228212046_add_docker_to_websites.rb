class AddDockerToWebsites < ActiveRecord::Migration[5.2]
  def change
    add_column :websites, :docker_image_name, :string
    add_column :websites, :docker_container_cmd, :string
    add_column :websites, :docker_container_volume_file_path, :string
    add_column :websites, :docker_container_port, :integer
    add_column :websites, :docker_host_port, :integer
  end
end
