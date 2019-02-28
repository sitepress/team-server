class Websites::ResourcesController < ApplicationController
  before_action :load_website
  before_action :load_resource, except: :index

  def index
    @resources = @website.resources
  end

  def update
    @resource.source = resource_params.fetch(:source)
    if @resource.save
      flash[:success] = "Updated #{@resource.request_path}"
      redirect_to [:edit, @website, @resource]
    else
      render :edit
    end
  end

  def preview
    render_page @resource.sitepress
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

    def render_page(page)
      render inline: page.body,
        type: page.asset.template_extensions.last,
        layout: page.data.fetch("layout", nil),
        content_type: page.mime_type.to_s
    end
end
