require 'spec_helper'

describe Ask do
    
  describe "index" do
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
            click_button "location_filter"
            click_link "#{ask.locations.first.name}"
            expect(page).to have_selector "tr#ask_#{ask.id}"
          end
          it "should not show asks without the selected location", js: true do
            click_button "location_filter"
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
            click_button "category_filter"
            click_link "#{ask.categories.first.name}"
            expect(page).to have_selector "tr#ask_#{ask.id}"
          end
          it "should not show asks without the selected category", js: true do
            click_button "category_filter"
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
            click_button "day_filter"
            click_link "#{ask.meetup_times.first.day}"
            expect(page).to have_selector "tr#ask_#{ask.id}"
          end
          it "should not show asks without the selected day", js: true do
            click_button "day_filter"
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
            click_button "time_filter"
            click_link "#{ask.meetup_times.first.period}"
            expect(page).to have_selector "tr#ask_#{ask.id}"
          end
          it "should not show asks without the selected time", js: true do
            click_button "time_filter"
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
          click_button "category_filter"
          click_link "#{ask.categories.first.name}"
          expect(page).to have_selector "tr#ask_#{other_ask.id}"
          click_button "location_filter"
          click_link "#{ask.locations.first.name}"
          expect(page).to_not have_selector "tr#ask_#{other_ask.id}"
          expect(page).to have_selector "tr#ask_#{ask.id}"
        end
      end
      context 'when no asks meet the filter', js: true do
        it 'should display a table row stating no mentee fit the parameters' do
          other_category = FactoryGirl.create(:category, official: true)
          visit mentors_sign_up_path
          click_button "category_filter"
          click_link "#{other_category.name}"
          #click_link "#{other_category.name}"
          expect(page).to have_selector "td",
            text: "There are currently no requests that " +
              "fit your parameters"
        end
      end
    end
  end
end
