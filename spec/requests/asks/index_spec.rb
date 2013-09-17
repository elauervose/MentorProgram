require 'spec_helper'

describe "ask index" do
  let!(:mentor_ask) { FactoryGirl.create :mentor_ask }
  let!(:pair_ask) { FactoryGirl.create :pair_ask }

  describe "authorization" do
    before { visit asks_path }

    it "should prevent non-admins from accessing the page" do
      expect(page).to_not have_selector 'table.asks'
    end
    it "should redirect non-admins to homepage" do
      expect(page).to have_selector 'h1', text: 'Mentor Program'
    end
  end

  describe "table of asks" do
    let(:admin) { FactoryGirl.create :admin }
    before do
      sign_in(admin)
      visit asks_path
    end

    it "should be present" do
      expect(page).to have_selector 'table.asks'
    end
    it "will show a MentorAsk" do
      expect(page).to have_selector "tr#ask_#{mentor_ask.id}"
    end
    it "will show a PairAsk" do
      expect(page).to have_selector "tr#ask_#{pair_ask.id}"
    end
  end
end
