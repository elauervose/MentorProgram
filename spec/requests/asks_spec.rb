require 'spec_helper'

describe "Asks" do
  before :all do
    load "#{Rails.root}/db/seeds.rb"
  end
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
      it "should redirect to the mentee thank you page" do
        expect(page).to have_selector 'h2',
          text: "Your request for a mentor has been received"
      end
    end
  end
  describe "with new category" do
    before do
      visit new_ask_path
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
      fill_in "Other", with: "new category"
    end
    
   it "should create a new category" do
    expect { 
      click_button "Submit Mentor Request Form"
    }.to change(Category, :count).by(1)
   end
   it "should associate the new category with the ask" do
     click_button "Submit Mentor Request Form"
     expect(Ask.last.categories.find_by name: "new category").to_not be_nil
   end
  end

end
