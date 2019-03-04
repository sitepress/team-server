require 'rails_helper'

RSpec.describe "docker_preview_servers/edit", type: :view do
  before(:each) do
    @docker_preview_server = assign(:docker_preview_server, DockerPreviewServer.create!(
      :website => nil,
      :image_name => "MyString",
      :container_cmd => "MyString",
      :container_volume_path => "MyString",
      :container_port => 1,
      :host_port => 1
    ))
  end

  it "renders the edit docker_preview_server form" do
    render

    assert_select "form[action=?][method=?]", docker_preview_server_path(@docker_preview_server), "post" do

      assert_select "input[name=?]", "docker_preview_server[website_id]"

      assert_select "input[name=?]", "docker_preview_server[image_name]"

      assert_select "input[name=?]", "docker_preview_server[container_cmd]"

      assert_select "input[name=?]", "docker_preview_server[container_volume_path]"

      assert_select "input[name=?]", "docker_preview_server[container_port]"

      assert_select "input[name=?]", "docker_preview_server[host_port]"
    end
  end
end
