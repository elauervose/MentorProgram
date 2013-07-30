require 'spec_helper'

describe "answers/new" do
  before(:each) do
    assign(:answer, stub_model(Answer,
      :name => "MyString",
      :email => "MyString",
      :ask => nil
    ).as_new_record)
  end

  it "renders new answer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", answers_path, "post" do
      assert_select "input#answer_name[name=?]", "answer[name]"
      assert_select "input#answer_email[name=?]", "answer[email]"
      assert_select "input#answer_ask[name=?]", "answer[ask]"
    end
  end
end
