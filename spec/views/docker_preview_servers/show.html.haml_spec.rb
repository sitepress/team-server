require 'rails_helper'

RSpec.describe "docker_preview_servers/show", type: :view do
  before(:each) do
    @docker_preview_server = assign(:docker_preview_server, DockerPreviewServer.create!(
      :website => nil,
      :image_name => "Image Name",
      :container_cmd => "Container Cmd",
      :container_volume_path => "Container Volume Path",
      :container_port => 2,
      :host_port => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Image Name/)
    expect(rendered).to match(/Container Cmd/)
    expect(rendered).to match(/Container Volume Path/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
