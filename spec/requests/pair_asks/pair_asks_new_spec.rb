require 'spec_helper'

describe MentorAsk do

  before :all do
      days = %w{Monday Tuesday Wednesday Thursday Friday Saturday Sunday }
      periods = ["Morning", "Afternoon", "Evening"]
      days.each do |day|
        periods.each do |period|
          MeetupTime.create(day: day, period: period)
        end
      end
    end

  describe "new pair_ask" do
    let!(:location) { FactoryGirl.create :location }
    let!(:meetup_time) { MeetupTime.first }

    before { visit new_pair_ask_path }
    it "show the request form" do
      expect(page).to have_selector 'h1', text: "Pairing Request Form"
    end
    context "with valid information" do
      before do
        fill_in "Name", with: "Test User"
        fill_in "Email", with: "text@example.com"
        check location.name
        check "pair_ask_meetup_times_#{meetup_time.id}"
        fill_in "pair_ask_description", with: "What I want to pair about"
        click_button "Submit Pairing Request Form"
      end

      it "should create a new pair_ask" do
        expect(PairAsk.find_by(name: "Test User")).to_not be_nil
      end
      it "should redirect to the pair thank you page" do
        expect(page).to have_selector 'h2',
          text: "Your request for a pair has been received"
      end
    end
    context "selections on form rerender" do
      describe "for locations" do
        it "should have selected location still selected" do
          check location.name
          click_button "Submit Pairing Request Form"
          expect(page).to have_checked_field location.name
        end
      end
      describe "for meetup times" do
        it "should have selected times still selected" do
          check "pair_ask_meetup_times_#{meetup_time.id}"
          click_button "Submit Pairing Request Form"
          expect(page).to have_checked_field(
            "pair_ask_meetup_times_#{meetup_time.id}")
        end
      end
    end
    context "when information fails validations" do
      before { click_button "Submit Pairing Request Form" }
      it "should rerender the form" do
        expect(page).to have_selector 'h1', text: "Pairing Request Form"
      end
      it "should display a message about why information was not valid" do
        expect(page).to have_selector 'div.error_explanation'
      end
    end
    context "without checked options" do
      before do
        fill_in "Name", with: "Test User"
        fill_in "Email", with: "text@example.com"
        fill_in "pair_ask_description", with: "What I want to pair about"
      end

      it "rerenders the form" do
        click_button "Submit Pairing Request Form"
        expect(page).to have_selector 'h1', text: "Pairing Request Form"
      end
      it "does not create a new pair_ask" do
        expect { click_button "Submit Pairing Request Form" }.
          to_not change(PairAsk, :count)
      end
    end
  end

end

