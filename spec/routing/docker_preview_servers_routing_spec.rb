require "rails_helper"

RSpec.describe DockerPreviewServersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/docker_preview_servers").to route_to("docker_preview_servers#index")
    end

    it "routes to #new" do
      expect(:get => "/docker_preview_servers/new").to route_to("docker_preview_servers#new")
    end

    it "routes to #show" do
      expect(:get => "/docker_preview_servers/1").to route_to("docker_preview_servers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/docker_preview_servers/1/edit").to route_to("docker_preview_servers#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/docker_preview_servers").to route_to("docker_preview_servers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/docker_preview_servers/1").to route_to("docker_preview_servers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/docker_preview_servers/1").to route_to("docker_preview_servers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/docker_preview_servers/1").to route_to("docker_preview_servers#destroy", :id => "1")
    end
  end
end
