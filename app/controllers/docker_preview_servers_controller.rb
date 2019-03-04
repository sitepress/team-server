class DockerPreviewServersController < ApplicationController
  before_action :set_docker_preview_server, only: [:show, :edit, :update, :destroy]

  # GET /docker_preview_servers
  # GET /docker_preview_servers.json
  def index
    @docker_preview_servers = DockerPreviewServer.all
  end

  # GET /docker_preview_servers/1
  # GET /docker_preview_servers/1.json
  def show
  end

  # GET /docker_preview_servers/new
  def new
    @docker_preview_server = DockerPreviewServer.new
  end

  # GET /docker_preview_servers/1/edit
  def edit
  end

  # POST /docker_preview_servers
  # POST /docker_preview_servers.json
  def create
    @docker_preview_server = DockerPreviewServer.new(docker_preview_server_params)

    respond_to do |format|
      if @docker_preview_server.save
        format.html { redirect_to @docker_preview_server, notice: 'Docker preview server was successfully created.' }
        format.json { render :show, status: :created, location: @docker_preview_server }
      else
        format.html { render :new }
        format.json { render json: @docker_preview_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /docker_preview_servers/1
  # PATCH/PUT /docker_preview_servers/1.json
  def update
    respond_to do |format|
      if @docker_preview_server.update(docker_preview_server_params)
        format.html { redirect_to @docker_preview_server, notice: 'Docker preview server was successfully updated.' }
        format.json { render :show, status: :ok, location: @docker_preview_server }
      else
        format.html { render :edit }
        format.json { render json: @docker_preview_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /docker_preview_servers/1
  # DELETE /docker_preview_servers/1.json
  def destroy
    @docker_preview_server.destroy
    respond_to do |format|
      format.html { redirect_to docker_preview_servers_url, notice: 'Docker preview server was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_docker_preview_server
      @docker_preview_server = DockerPreviewServer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def docker_preview_server_params
      params.require(:docker_preview_server).permit(:website_id, :image_name, :container_cmd, :container_volume_path, :container_port, :host_port)
    end
end
