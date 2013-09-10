require 'spec_helper'
describe MentorAsk do
  describe "show page" do
    let(:mentor_ask) { FactoryGirl.create :mentor_ask }

    before { visit mentor_ask_path(mentor_ask) }

    it "should have information about the mentee request" do
      expect(page).to have_selector 'p', text: mentor_ask.name
    end
    it "should have a link to become their mentor" do
      expect(page).to have_link 'Become Mentor!',
        href: "/answers/new?ask_id=#{mentor_ask.id}"     
    end
    it "should have a link to mentors sign up page" do
      expect(page).to have_link "Return to Mentees List",
        href: mentors_sign_up_path
    end
  end
end
