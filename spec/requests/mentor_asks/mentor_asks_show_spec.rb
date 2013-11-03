require 'spec_helper'
describe MentorAsk do
  let(:mentor_ask) { FactoryGirl.create :mentor_ask }
  describe "show page" do

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
  describe "when a token is supplied" do
    context "but the wrong token" do
      it "should not have a link to delete the request" do
        visit mentor_ask_path(mentor_ask, token: "invalid_token")
        expect(page).to have_no_link "delete_mentor_ask"
      end
    end
    context "and the token is the right one" do
      before { visit mentor_ask_path(mentor_ask, token: mentor_ask.token) }
      it "should have a link to delete the request" do
        expect(page).to have_link "delete_mentor_ask"
      end
      context "clicking the delete button" do
        before { click_link "delete_mentor_ask" }

        it "should delete the ask" do
          expect(Ask.find_by(id: mentor_ask.id)).to be_nil
        end
        it "should redirect to the homepage" do
          expect(current_path).to eq root_path
        end
      end
    end
  end
end
