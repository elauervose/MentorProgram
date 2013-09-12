require 'spec_helper'
describe MentorAsk do
  describe "show page" do
    let(:pair_ask) { FactoryGirl.create :pair_ask }

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
end
