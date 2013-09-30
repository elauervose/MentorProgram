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

    describe "destroying an ask" do
      it "should have a link to destroy the ask" do
        expect(page).to have_link "Delete"
      end
      it "The ask should no longer exist", js: true do
        click_link 'Delete', href: "/asks/#{mentor_ask.id}"
        page.driver.browser.switch_to.alert.accept
        expect(current_path).to eq '/asks'
        expect(Ask.find_by(id: mentor_ask.id)).to be_nil
      end
    end
    describe "editing an ask" do
      it "should have a link to edit a MentorAsk" do
        expect(page).to have_link "Edit", edit_mentor_ask_path(mentor_ask)
      end
      it "should have a link to edit a PairAsk" do
        expect(page).to have_link "Edit", edit_pair_ask_path(pair_ask)
      end
    end
  end
end
