require 'rails_helper'

RSpec.describe "docker_preview_servers/new", type: :view do
  before(:each) do
    assign(:docker_preview_server, DockerPreviewServer.new(
      :website => nil,
      :image_name => "MyString",
      :container_cmd => "MyString",
      :container_volume_path => "MyString",
      :container_port => 1,
      :host_port => 1
    ))
  end

  it "renders new docker_preview_server form" do
    render

    assert_select "form[action=?][method=?]", docker_preview_servers_path, "post" do

      assert_select "input[name=?]", "docker_preview_server[website_id]"

      assert_select "input[name=?]", "docker_preview_server[image_name]"

      assert_select "input[name=?]", "docker_preview_server[container_cmd]"

      assert_select "input[name=?]", "docker_preview_server[container_volume_path]"

      assert_select "input[name=?]", "docker_preview_server[container_port]"

      assert_select "input[name=?]", "docker_preview_server[host_port]"
    end
  end
end
