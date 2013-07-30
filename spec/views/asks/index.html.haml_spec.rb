require 'spec_helper'

describe "asks/index" do
  before(:each) do
    assign(:asks, [
      stub_model(Ask,
        :name => "Name",
        :email => "Email",
        :location => "Location",
        :days => "Days",
        :times => "Times",
        :project_desc => "Project Desc",
        :category => "Category"
      ),
      stub_model(Ask,
        :name => "Name",
        :email => "Email",
        :location => "Location",
        :days => "Days",
        :times => "Times",
        :project_desc => "Project Desc",
        :category => "Category"
      )
    ])
  end

  it "renders a list of asks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Location".to_s, :count => 2
    assert_select "tr>td", :text => "Days".to_s, :count => 2
    assert_select "tr>td", :text => "Times".to_s, :count => 2
    assert_select "tr>td", :text => "Project Desc".to_s, :count => 2
    assert_select "tr>td", :text => "Category".to_s, :count => 2
  end
end
