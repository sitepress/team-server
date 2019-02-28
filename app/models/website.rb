class Website < ApplicationRecord
  # delegate :resources, to: :sitepress

  def sitepress
    @_sitepress ||= project.site.tap do |s|
      # Path loaded from a project is relative to its root; this
      # should make it relative to the project path.
      # TODO: Make this work at the project or site level so this is less
      # hacky and brittle.
      s.root_path = file_path
    end
  end

  def resources
    Enumerator.new do |y|
      sitepress.resources.each do |resource|
        y << Resource.new(resource)
      end
    end
  end

  def find_resource_by_id(request_path)
    Resource.new sitepress.get CGI.unescape request_path
  end

  def project
    Sitepress::Project.new config_file: config_file_path
  end

  def renderer(resource)
    Sitepress::RenderingContext.new(resource: resource.sitepress, site: self.sitepress)
  end

  private
    def config_file_path
      Pathname.new(file_path).join(Sitepress::Project::DEFAULT_CONFIG_FILE)
    end
end
