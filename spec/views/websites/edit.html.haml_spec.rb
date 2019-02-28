require 'rails_helper'

RSpec.describe "websites/edit", type: :view do
  before(:each) do
    @website = assign(:website, Website.create!(
      :name => "MyString",
      :file_path => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit website form" do
    render

    assert_select "form[action=?][method=?]", website_path(@website), "post" do

      assert_select "input[name=?]", "website[name]"

      assert_select "input[name=?]", "website[file_path]"

      assert_select "textarea[name=?]", "website[description]"
    end
  end
end
