require 'spec_helper'

describe "asks/show" do
  before(:each) do
    @ask = assign(:ask, stub_model(Ask,
      :name => "Name",
      :email => "Email",
      :location => "Location",
      :days => "Days",
      :times => "Times",
      :project_desc => "Project Desc",
      :category => "Category"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Email/)
    rendered.should match(/Location/)
    rendered.should match(/Days/)
    rendered.should match(/Times/)
    rendered.should match(/Project Desc/)
    rendered.should match(/Category/)
  end
end
