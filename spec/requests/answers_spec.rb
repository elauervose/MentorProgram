require 'spec_helper'

describe "Answers" do
  describe "mentor signup page" do
    before { visit '/mentors/sign_up' }
    it "shows the mentor form" do
      expect(page).to have_selector 'h1', text: "Find Your Mentee"
    end
    it "has a table of available mentees" do
      expect(page).to have_selector 'table.mentees'
    end
  end
end
