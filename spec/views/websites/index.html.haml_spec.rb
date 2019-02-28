require 'rails_helper'

RSpec.describe "websites/index", type: :view do
  before(:each) do
    assign(:websites, [
      Website.create!(
        :name => "Name",
        :file_path => "File Path",
        :description => "MyText"
      ),
      Website.create!(
        :name => "Name",
        :file_path => "File Path",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of websites" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "File Path".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
