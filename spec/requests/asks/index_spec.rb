require 'spec_helper'

describe "ask index" do
  let!(:mentor_ask) { FactoryGirl.create :mentor_ask }
  let!(:pair_ask) { FactoryGirl.create :pair_ask }

  describe "table of asks" do
    before { visit asks_path }

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
