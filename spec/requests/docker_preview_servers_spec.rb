require 'rails_helper'

RSpec.describe "DockerPreviewServers", type: :request do
  describe "GET /docker_preview_servers" do
    it "works! (now write some real specs)" do
      get docker_preview_servers_path
      expect(response).to have_http_status(200)
    end
  end
end
