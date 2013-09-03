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

  describe "new ask" do
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
    context "selections on form rerender" do
      describe "for locations" do
        it "should have selected location still selected" do
          check "Inner SE"
          click_button "Submit Mentor Request Form"
          expect(page).to have_checked_field "Inner SE"
        end
      end
      describe "for meetup times" do
        it "should have selected times still selected" do
          check "ask_meetup_times_6"
          click_button "Submit Mentor Request Form"
          expect(page).to have_checked_field "ask_meetup_times_6"
        end
      end
      describe "for categories" do
        it "should have selected categories still selected" do
          check "Basic Web"
          click_button "Submit Mentor Request Form"
          expect(page).to have_checked_field "Basic Web"
        end
        it "should retain value of user created category" do
          fill_in "Other", with: "new category"
          click_button "Submit Mentor Request Form"
          expect(page).to have_field "ask_categories_attributes_0_name",
            with: "new category", visible: true
        end
        specify "there are no additional input fields added" do
          check "Basic Web"
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
      it "does not create a new ask" do
        expect { click_button "Submit Mentor Request Form" }.
          to_not change(Ask, :count)
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
        check "Inner SE"
        check "Downtown"
        check "ask_meetup_times_6"
        check "ask_meetup_times_11"
        check "Basic Web"
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
  end
  
  describe "asks index" do
    let!(:ask) { FactoryGirl.create :ask }
    before { visit mentors_sign_up_path }

    it "shows the mentor form" do
      expect(page).to have_selector 'h1', text: "Find Your Mentee"
    end
    describe "table of mentee asks" do
      it "should be present on page" do
        expect(page).to have_selector 'table.mentees'
      end
      it "contains a row for the mentee ask" do
        expect(page).to have_selector "tr#ask_#{ask.id}"
      end
      it "has a link to become a mentor" do
        expect(page).to have_link "answer_ask_#{ask.id}"
      end
      it "has a link to the full details of the request" do
        expect(page).to have_link "See Availability", href: ask_path(ask)
      end
    end

    describe "filtering asks" do
      let!(:other_ask) { FactoryGirl.create :ask }
      before do
        visit mentors_sign_up_path
      end
      context "by location" do
        it "should have a dropdown menu for locations", js: true do
          expect(page).to have_css "button#location_filter"
        end
        describe "selecting a filter" do
          it "should show asks with the selected location", js: true do
            click_link "#{ask.locations.first.name}"
            expect(page).to have_selector "tr#ask_#{ask.id}"
          end
          it "should not show asks without the selected location", js: true do
            click_link "#{ask.locations.first.name}"
            expect(page).to_not have_selector "tr#ask_#{other_ask.id}"
          end
        end
      end
      context "by category" do
        let!(:user_category) { FactoryGirl.create(:category) }
        before do
          ask.categories.first.official = true
          ask.save
          other_ask.categories.first.official = true
          other_ask.save
          visit mentors_sign_up_path
        end
        it "should have a dropdown menu for categories", js: true do
          user_category
          expect(page).to have_css "button#category_filter"
        end
        it "should not have a link for a user category", js: true do
          expect(page).to_not have_link "#{user_category.name}"
        end
        describe "selecting a filter" do
          it "should show asks with the selected category", js: true do
            click_link "#{ask.categories.first.name}"
            expect(page).to have_selector "tr#ask_#{ask.id}"
          end
          it "should not show asks without the selected category", js: true do
            click_link "#{ask.categories.first.name}"
            expect(page).to_not have_selector "tr#ask_#{other_ask.id}"
          end
        end
      end
      context "by day" do
        it "should have a dropdown menu for days", js: true do
          expect(page).to have_css "button#day_filter"
        end
        describe "selecting a filter" do
          it "should show asks with the selected day", js: true do
            click_link "#{ask.meetup_times.first.day}"
            expect(page).to have_selector "tr#ask_#{ask.id}"
          end
          it "should not show asks without the selected day", js: true do
            click_link "#{ask.meetup_times.first.day}"
            expect(page).to_not have_selector "tr#ask_#{other_ask.id}"
          end
        end
      end
      context "by time" do
        it "should have a dropdown menu for times", js: true do
          expect(page).to have_css "button#time_filter"
        end
        describe "selecting a filter" do
          it "should show asks with the selected time", js: true do
            click_link "#{ask.meetup_times.first.period}"
            expect(page).to have_selector "tr#ask_#{ask.id}"
          end
          it "should show asks with time of 'any' when a time selected",
            js: true do
            meetup = FactoryGirl.create :meetup_time, period: 'Any'
            ask.meetup_times.delete_all
            ask.meetup_times << meetup
            ask.save
            visit mentors_sign_up_path
            click_link "Morning"
            expect(page).to have_selector "tr#ask_#{ask.id}"
          end

          it "should not show asks without the selected time", js: true do
            click_link "#{ask.meetup_times.first.period}"
            expect(page).to_not have_selector "tr#ask_#{other_ask.id}"
          end
        end
      end
      context 'by more than one filter' do
        it "should filter out asks that do not meet all conditions", js: true do
          category = ask.categories.first
          category.official = true
          category.save
          other_ask.categories << category
          other_ask.save
          visit mentors_sign_up_path
          click_link "#{ask.categories.first.name}"
          expect(page).to have_selector "tr#ask_#{other_ask.id}"
          click_link "#{ask.locations.first.name}"
          expect(page).to_not have_selector "tr#ask_#{other_ask.id}"
          expect(page).to have_selector "tr#ask_#{ask.id}"
        end
      end
      context 'when no asks meet the filter', js: true do
        it 'should display a table row stating no mentee fit the parameters' do
          other_category = FactoryGirl.create :category
          visit mentors_sign_up_path
          click_link "#{other_category.name}"
          expect(page).to have_selector "tr",
            text: "There are currently no requests that
              fit your parameters"
        end
      end
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
