require 'rails_helper'

RSpec.describe "docker_preview_servers/index", type: :view do
  before(:each) do
    assign(:docker_preview_servers, [
      DockerPreviewServer.create!(
        :website => nil,
        :image_name => "Image Name",
        :container_cmd => "Container Cmd",
        :container_volume_path => "Container Volume Path",
        :container_port => 2,
        :host_port => 3
      ),
      DockerPreviewServer.create!(
        :website => nil,
        :image_name => "Image Name",
        :container_cmd => "Container Cmd",
        :container_volume_path => "Container Volume Path",
        :container_port => 2,
        :host_port => 3
      )
    ])
  end

  it "renders a list of docker_preview_servers" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Image Name".to_s, :count => 2
    assert_select "tr>td", :text => "Container Cmd".to_s, :count => 2
    assert_select "tr>td", :text => "Container Volume Path".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
