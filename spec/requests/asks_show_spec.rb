require 'spec_helper'
describe Ask do
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
