require "pathname"

class Website < ApplicationRecord
  # delegate :resources, to: :sitepress

  def sitepress
    @_sitepress ||= Sitepress::Site.new(root_path: file_path)
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
end
