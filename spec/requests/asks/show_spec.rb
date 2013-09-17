require 'spec_helper'

describe "ask show page" do
  let(:admin) { FactoryGirl.create :admin }
  before do
    sign_in(admin)
  end

  describe "deleting an ask" do
    let(:ask) { FactoryGirl.create :ask }
    before { visit ask_path(ask) }

    it "should have a link to delete the ask" do
      expect(page).to have_link 'delete', href: ask_path(ask)
    end
    it "the ask should be removed when deleted", js: true do
      click_link 'delete'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_selector 'table.asks'
      expect(Ask.find_by(id: ask.id)).to be_nil
    end
  end

  context "for a PairAsk" do
    let(:pair_ask) { FactoryGirl.create :pair_ask }
    before { visit ask_path(pair_ask) }

    it "should show the right ask" do
      expect(page).to have_selector 'p', text: pair_ask.name
    end
  end

  context "for a MentorAsk" do
    let(:mentor_ask) { FactoryGirl.create :mentor_ask }
    before { visit ask_path(mentor_ask) }

    it "should show the right ask" do
      expect(page).to have_selector 'p', text: mentor_ask.name
    end
    it "should have the categories of the ask" do
      expect(page).to have_selector 'p', text: mentor_ask.categories.first.name
    end
  end
end
