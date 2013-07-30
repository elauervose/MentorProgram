require 'spec_helper'

describe "answers/edit" do
  before(:each) do
    @answer = assign(:answer, stub_model(Answer,
      :name => "MyString",
      :email => "MyString",
      :ask => nil
    ))
  end

  it "renders the edit answer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", answer_path(@answer), "post" do
      assert_select "input#answer_name[name=?]", "answer[name]"
      assert_select "input#answer_email[name=?]", "answer[email]"
      assert_select "input#answer_ask[name=?]", "answer[ask]"
    end
  end
end
