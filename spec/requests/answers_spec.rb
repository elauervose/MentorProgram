require 'spec_helper'

describe "Answers" do
  let!(:ask) { FactoryGirl.create(:ask) }

  describe "routes" do
    it "should direct '/mentors' to answers#sign_up" do
      visit '/mentors'
      expect(page).to have_selector 'h1', text: 'Become a Mentor'
    end
  end

  describe "mentor signup page" do
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
          it "should not show asks without the selected time", js: true do
            click_link "#{ask.meetup_times.first.period}"
            expect(page).to_not have_selector "tr#ask_#{other_ask.id}"
          end
        end
      end
      context 'by more than one filter' do
        it "should filter out aks that do not meet all conditions", js: true do
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
    end
  end
  
  describe "answering a request" do
    before do
      visit mentors_sign_up_path
      click_link 'answer_ask_1'
    end
    it "should take me to the new answer page" do
      expect(page).to have_selector "p",
        text: "You are about to become a mentor for one very lucky mentee"
    end
    describe "and filling out the form" do
      context "with valid information" do
        before do
          fill_in "Name", with: "the answerer"
          fill_in "email address", with: "answerer@example.com"
        end

        it "should create a new answer" do
          expect { click_button "Go! »"}.to change(Answer, :count).by(1)
        end
        it "should mark the mentee request as answered" do
          click_button "Go! »"
          ask.reload
          expect(ask.answered?).to be_true
        end
        it "should redirect to the mentors thank you page" do
          click_button "Go! »"
          expect(page).to have_selector "h1",
            text: "Thank You For Being A Mentor"
        end
      end
      context "with invalid information" do
        it "should rerender the form" do
          click_button "Go! »"
          expect(page).to have_selector "p",
            text: "You are about to become a mentor for one very lucky mentee"
        end
        it "should display a message about why information ws not valid" do
          expect(page).to have_selector 'div.error_explanation'
        end
        it "should not create a new answer" do
          expect { click_button "Go! »"}.to_not change(Answer, :count)
        end
      end
    end
  end

  describe "answered mentee requests" do
    it "are not present" do
      answered_mentee = FactoryGirl.create(:ask)
      answered_mentee.answered = true
      answered_mentee.save
      visit mentors_sign_up_path
      expect(page).to_not have_selector "tr#ask_#{answered_mentee.id}"
    end
  end

end
