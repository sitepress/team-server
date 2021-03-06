class Websites::ResourcesController < ApplicationController
  before_action :load_website
  before_action :load_resource, except: :index

  def index
    @resources = @website.resources
  end

  def update
    @resource.source = resource_params.fetch(:source)
    if @resource.save
      flash[:success] = "Updated #{@resource.file_path}"
      redirect_to [:edit, @website, @resource]
    else
      render :edit
    end
  end

  def preview
    redirect_to @website.preview_url(params[:id]).to_s
  end

  private
    def resource_params
      params.require(:resource).permit(:source)
    end

    def load_website
      @website = Website.find(params[:website_id])
    end

    def load_resource
      @resource = @website.find_resource_by_id params[:id]
    end
end
