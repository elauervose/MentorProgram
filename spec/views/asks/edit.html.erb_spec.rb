require 'spec_helper'

describe "asks/edit" do
  before(:each) do
    @ask = assign(:ask, stub_model(Ask,
      :name => "MyString",
      :email => "MyString",
      :location => "MyString",
      :days => "MyString",
      :times => "MyString",
      :project_desc => "MyString",
      :category => "MyString"
    ))
  end

  it "renders the edit ask form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", ask_path(@ask), "post" do
      assert_select "input#ask_name[name=?]", "ask[name]"
      assert_select "input#ask_email[name=?]", "ask[email]"
      assert_select "input#ask_location[name=?]", "ask[location]"
      assert_select "input#ask_days[name=?]", "ask[days]"
      assert_select "input#ask_times[name=?]", "ask[times]"
      assert_select "input#ask_project_desc[name=?]", "ask[project_desc]"
      assert_select "input#ask_category[name=?]", "ask[category]"
    end
  end
end
