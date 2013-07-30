require 'spec_helper'

describe "answers/index" do
  before(:each) do
    assign(:answers, [
      stub_model(Answer,
        :name => "Name",
        :email => "Email",
        :ask => nil
      ),
      stub_model(Answer,
        :name => "Name",
        :email => "Email",
        :ask => nil
      )
    ])
  end

  it "renders a list of answers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
