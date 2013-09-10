require 'spec_helper'

describe MentorAsk do

  before :all do
      days = %w{Monday Tuesday Wednesday Thursday Friday Saturday Sunday }
      periods = ["Morning", "Afternoon", "Evening"]
      days.each do |day|
        periods.each do |period|
          MeetupTime.create(day: day, period: period)
        end
      end
    end

  describe "new mentor_ask" do
    let!(:location) { FactoryGirl.create :location }
    let!(:meetup_time) { MeetupTime.first }
    let!(:category) { FactoryGirl.create(:category, official: true )}

    before { visit new_mentor_ask_path }
    it "show the request form" do
      expect(page).to have_selector 'h1', text: "Mentor Request Form"
    end
    context "with valid information" do
      before do
        fill_in "Name", with: "Test User"
        fill_in "Email", with: "text@example.com"
        check location.name
        check "ask_meetup_times_#{meetup_time.id}"
        check category.name
        fill_in "ask_description", with: "What I want to learn about"
        click_button "Submit Mentor Request Form"
      end

      it "should create a new mentor_ask" do
        expect(MentorAsk.find_by(name: "Test User")).to_not be_nil
      end
      it "should redirect to the mentee thank you page" do
        expect(page).to have_selector 'h2',
          text: "Your request for a mentor has been received"
      end
    end
    context "selections on form rerender" do
      describe "for locations" do
        it "should have selected location still selected" do
          check location.name
          click_button "Submit Mentor Request Form"
          expect(page).to have_checked_field location.name
        end
      end
      describe "for meetup times" do
        it "should have selected times still selected" do
          check "ask_meetup_times_#{meetup_time.id}"
          click_button "Submit Mentor Request Form"
          expect(page).to have_checked_field(
            "ask_meetup_times_#{meetup_time.id}")
        end
      end
      describe "for categories" do
        it "should have selected categories still selected" do
          check category.name
          click_button "Submit Mentor Request Form"
          expect(page).to have_checked_field category.name
        end
        it "should retain value of user created category" do
          fill_in "Other", with: "new category"
          click_button "Submit Mentor Request Form"
          expect(page).to have_field "ask_categories_attributes_0_name",
            with: "new category", visible: true
        end
        specify "there are no additional input fields added" do
          check category.name
          fill_in "Other", with: "new category"
          click_button "Submit Mentor Request Form"
          expect(page).to_not have_field "ask_categories_attributes_1_name"
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
      it "does not create a new mentor_ask" do
        expect { click_button "Submit Mentor Request Form" }.
          to_not change(MentorAsk, :count)
      end
      context "with a user created category" do
        it "does not create the new category" do
          expect { click_button "Submit Mentor Request Form" }.
            to_not change(Category, :count)
        end
      end
    end

    describe "with new category" do
      before do
        fill_in "Name", with: "Test User"
        fill_in "Email", with: "text@example.com"
        check location.name
        check "ask_meetup_times_#{meetup_time.id}"
        check category.name
        fill_in "ask_description", with: "What I want to learn about"
        fill_in "Other", with: "new category"
      end
      
      it "should create a new category" do
        expect { click_button "Submit Mentor Request Form"}.
          to change(Category, :count).by(1)
      end
      it "should not create an official category" do
        click_button "Submit Mentor Request Form"
        category = Category.last
        expect(category.official?).to be_false
      end
      it "should associate the new category with the mentor_ask" do
        click_button "Submit Mentor Request Form"
        expect(MentorAsk.last.categories.find_by name: "new category").to_not be_nil
      end
      it "should not be visible to other visits to the page" do
        click_button "Submit Mentor Request Form"
        unofficial_category = Category.last
        visit new_mentor_ask_path
        expect(page).to_not have_selector(
           "input#ask_categories_#{unofficial_category.id}")
      end
    end
  end
end

