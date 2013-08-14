require 'spec_helper'

describe "Answers" do
  let!(:ask) { FactoryGirl.create(:ask) }
  describe "mentor signup page" do
    before { visit '/mentors/sign_up' }

    it "shows the mentor form" do
      expect(page).to have_selector 'h1', text: "Find Your Mentee"
    end
    it "has a table for mentee asks" do
      expect(page).to have_selector 'table.mentees'
    end
    it "contains a row for the mentee ask" do
      expect(page).to have_selector "tr#ask_#{ask.id}"
    end
  end
  
  describe "answering a request" do
    before do
      visit '/mentors/sign_up'
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
      end
      context "with invalid information" do
        it "should rerender the form" do
          click_button "Go! »"
          expect(page).to have_selector "p",
            text: "You are about to become a mentor for one very lucky mentee"
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
      visit '/mentors/sign_up'
      expect(page).to_not have_selector "tr#ask_#{answered_mentee.id}"
    end
  end

end
