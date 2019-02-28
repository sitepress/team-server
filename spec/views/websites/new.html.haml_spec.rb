require 'rails_helper'

RSpec.describe "websites/new", type: :view do
  before(:each) do
    assign(:website, Website.new(
      :name => "MyString",
      :file_path => "MyString",
      :description => "MyText"
    ))
  end

  it "renders new website form" do
    render

    assert_select "form[action=?][method=?]", websites_path, "post" do

      assert_select "input[name=?]", "website[name]"

      assert_select "input[name=?]", "website[file_path]"

      assert_select "textarea[name=?]", "website[description]"
    end
  end
end
