require 'spec_helper'

describe "Asks" do
  before :all do
    load "#{Rails.root}/db/seeds.rb"
  end

  describe "routes" do
    it "should direct '/mentees' to ask#new" do
      visit '/mentees'
      expect(page).to have_selector 'h1', text: 'Find a Mentor'
    end 
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
        check "ask_meetup_times_6"
        check "ask_meetup_times_11"
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
    context "checkboxes on form rerender" do
      describe "for locations" do
        specify "should have selected location still selected" do
          check "Inner SE"
          click_button "Submit Mentor Request Form"
          expect(page).to have_checked_field "Inner SE"
        end
      end
      describe "for meetup times" do
        specify" should have selected times still selected" do
          check "ask_meetup_times_6"
          click_button "Submit Mentor Request Form"
          expect(page).to have_checked_field "ask_meetup_times_6"
        end
      end
    end
    context "when information fails validations" do
      before { click_button "Submit Mentor Request Form" }
      it "should rerender the form" do
        expect(page).to have_selector 'h1', text: "Mentor Request Form"
      end
      it "should display a message about why information was not valid" do
        expect(page).to have_selector 'div.error_explanation'
      end
    end
    context "without checked options" do
      before do
        fill_in "Name", with: "Test User"
        fill_in "Email", with: "text@example.com"
        fill_in "ask_description", with: "What I want to learn about"
      end

      it "rerenders the form" do
        click_button "Submit Mentor Request Form"
        expect(page).to have_selector 'h1', text: "Mentor Request Form"
      end
      it "does not create a new ask" do
        expect { click_button "Submit Mentor Request Form" }.
          to_not change(Ask, :count)
      end
      context "with a user created category" do
        it "does not create the new category" do
          expect { click_button "Submit Mentor Request Form" }.
            to_not change(Category, :count)
        end
        it "submits successfully with only a user created category" do
          check "Downtown"
          check "ask_meetup_times_6"
          click_button "Submit Mentor Request Form"
          expect(page).to have_selector 'h2',
            text: "Your request for a mentor has been received"
        end
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
      check "ask_meetup_times_6"
      check "ask_meetup_times_11"
      check "Basic Web"
      fill_in "ask_description", with: "What I want to learn about"
      fill_in "Other", with: "new category"
    end
    
   it "should create a new category" do
    expect { 
      click_button "Submit Mentor Request Form"
    }.to change(Category, :count).by(1)
   end
   it "should not create an official category" do
     click_button "Submit Mentor Request Form"
     category = Category.last
     expect(category.official?).to be_false
   end
   it "should associate the new category with the ask" do
     click_button "Submit Mentor Request Form"
     expect(Ask.last.categories.find_by name: "new category").to_not be_nil
   end
   it "should not be visible to other visits to the page" do
     click_button "Submit Mentor Request Form"
     unofficial_category = Category.last
     visit new_ask_path
     expect(page).to_not have_selector(
       "input#ask_categories_#{unofficial_category.id}")
   end
  end

  describe "show page" do
    let(:ask) { FactoryGirl.create :ask }

    before { visit ask_path(ask) }

    it "should have information about the mentee request" do
      expect(page).to have_selector 'p', text: ask.name
    end
    it "should have a link to become their mentor" do
      expect(page).to have_link 'Become Mentor!',
        href: "/answers/new?ask_id=#{ask.id}"     
    end
    it "should have a link to mentors sign up page" do
      expect(page).to have_link "Return to Mentees List",
        href: mentors_sign_up_path
    end
  end


end
