require 'spec_helper'
describe MentorAsk do
  let(:pair_ask) { FactoryGirl.create :pair_ask }
  describe "show page" do
    before { visit pair_ask_path(pair_ask) }

    it "should have information about the pairing request" do
      expect(page).to have_selector 'p', text: pair_ask.name
    end
    it "should have a link to become their partner" do
      expect(page).to have_link 'Become Partner!',
        href: "/answers/new?ask_id=#{pair_ask.id}"     
    end
    it "should have a link to pairing sign up page" do
      expect(page).to have_link "Return to Pairing Requests List",
        href: pair_asks_path
    end
  end
  describe "when a token is supplied" do
    context "but the wrong token" do
      it "should not have a link to delete the request" do
        visit pair_ask_path(pair_ask, token: "invalid_token")
        expect(page).to have_no_link "delete_pair_ask"
      end
    end
    context "and the token is the right one" do
      before { visit pair_ask_path(pair_ask, token: pair_ask.token) }
      it "should have a link to delete the request" do
        expect(page).to have_link "delete_pair_ask"
      end
      context "clicking the delete button" do
        before { click_link "delete_pair_ask" }

        it "should delete the ask" do
          expect(Ask.find_by(id: pair_ask.id)).to be_nil
        end
        it "should redirect to the homepage" do
          expect(current_path).to eq root_path
        end
      end
    end
  end

end
