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
