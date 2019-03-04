class CreateDockerPreviewServers < ActiveRecord::Migration[5.2]
  def change
    create_table :docker_preview_servers do |t|
      t.references :website, foreign_key: true
      t.string :image_name
      t.string :container_cmd
      t.string :container_volume_path
      t.integer :container_port
      t.integer :host_port

      t.timestamps
    end
  end
end
