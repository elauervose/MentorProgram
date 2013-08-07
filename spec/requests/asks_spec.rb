require 'spec_helper'

describe "Asks" do
  describe "request form" do
    before { visit new_ask_path }
    it "show the request form" do
      expect(page).to have_selector 'h1', text: "Mentor Request Form"
    end
    context "with valid information" do
      before do
        fill_in "Name", with: "Test User"
        fill_in "Email", with: "text@example.com"
        check "Inner SE"
        check "Downtown"
        check "ask_meetup_times_9"
        check "ask_meetup_times_17"
        check "ask_meetup_times_29"
        check "ask_meetup_times_37"
        check "ask_meetup_times_42"
        check "ask_meetup_times_49"
        check "ask_meetup_times_6"
        check "ask_meetup_times_7"
        check "Basic Web"
        fill_in "ask_description", with: "What I want to learn about"
        click_button "Submit Mentor Request Form"
      end

      it "should create a new ask" do
        expect(Ask.find_by(name: "Test User")).to_not be_nil
      end
    end
  end
end
