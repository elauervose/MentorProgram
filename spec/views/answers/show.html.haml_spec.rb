require 'spec_helper'

describe "answers/show" do
  before(:each) do
    @answer = assign(:answer, stub_model(Answer,
      :name => "Name",
      :email => "Email",
      :ask => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Email/)
    rendered.should match(//)
  end
end
