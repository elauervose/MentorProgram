require 'spec_helper'

describe PairAsk do
    
  describe "index" do
    let!(:pair_ask) { FactoryGirl.create :pair_ask }

    describe "page content" do
      before { visit pair_asks_path }

      it "shows the pair form" do
        expect(page).to have_selector 'h1', text: "Find a Pairing Partner"
      end
      describe "table of pair asks" do
        it "should be present on page" do
          expect(page).to have_selector 'table.pairs'
        end
        it "contains a row for the pair ask" do
          expect(page).to have_selector "tr#ask_#{pair_ask.id}"
        end
        it "has a link to become a pair" do
          expect(page).to have_link "answer_ask_#{pair_ask.id}"
        end
        it "has a link to the full details of the request" do
          expect(page).to have_link "See Availability",
            href: pair_ask_path(pair_ask)
        end
      end
    end

    describe "filtering pair_asks" do
      let!(:other_pair_ask) { FactoryGirl.create(:pair_ask,
                                                meetup_times: [other_meetup]) }
      let(:other_meetup) { FactoryGirl.create(:meetup_time,
                                              day: "other_day",
                                              period: "other_time"
                                             ) }
      before { visit pair_asks_path }
      context "by location" do
        it "should have a dropdown menu for locations", js: true do
          expect(page).to have_css "button#location_filter"
        end
        describe "selecting a filter" do
          it "should show pair_asks with the selected location", js: true do
            click_button "location_filter"
            click_link "#{pair_ask.locations.first.name}"
            expect(page).to have_selector "tr#ask_#{pair_ask.id}"
          end
          it "should not show pair_asks without the selected location",
                                                              js: true do
            click_button "location_filter"
            click_link "#{pair_ask.locations.first.name}"
            expect(page).to have_no_selector "tr#ask_#{other_pair_ask.id}"
          end
        end
      end
       context "by day" do
        before { visit pair_asks_path }
        it "should have a dropdown menu for days", js: true do
          expect(page).to have_css "button#day_filter"
        end
        describe "selecting a filter" do
          it "should show asks with the selected day", js: true do
            click_button "day_filter"
            click_link "#{pair_ask.meetup_times.first.day}"
            expect(page).to have_selector "tr#ask_#{pair_ask.id}"
          end
          it "should not show pair_asks without the selected day", js: true do
            click_button "day_filter"
            click_link "#{pair_ask.meetup_times.first.day}"
            expect(page).to have_no_selector "tr#ask_#{other_pair_ask.id}"
          end
        end
      end
      context "by time" do
        before { visit pair_asks_path }
        it "should have a dropdown menu for times", js: true do
          expect(page).to have_css "button#time_filter"
        end
        describe "selecting a filter" do
          it "should show pair_asks with the selected time", js: true do
            click_button "time_filter"
            click_link "#{pair_ask.meetup_times.first.period}"
            expect(page).to have_selector "tr#ask_#{pair_ask.id}"
          end
          it "should not show pair_asks without the selected time",
                                                          js: true do
            click_button "time_filter"
            click_link "#{pair_ask.meetup_times.first.period}"
            expect(page).to have_no_selector "tr#ask_#{other_pair_ask.id}"
          end
        end
      end
      context 'by more than one filter' do
        it "should filter out pair_asks that do not meet all conditions",
                                                                js: true do
          period = pair_ask.meetup_times.first
          other_pair_ask.meetup_times << period
          other_pair_ask.save
          visit pair_asks_path
          click_button "time_filter"
          click_link "#{pair_ask.meetup_times.first.period}"
          expect(page).to have_selector "tr#ask_#{other_pair_ask.id}"
          click_button "location_filter"
          click_link "#{pair_ask.locations.first.name}"
          expect(page).to have_no_selector "tr#ask_#{other_pair_ask.id}"
          expect(page).to have_selector "tr#ask_#{pair_ask.id}"
        end
      end
      context 'when no pair_asks meet the filter', js: true do
        it 'should display a table row stating no pair fit the parameters' do
          other_location = FactoryGirl.create :location
          visit pair_asks_path
          click_button "location_filter"
          click_link "#{other_location.name}"
          expect(page).to have_selector "td",
            text: "There are currently no requests that " +
              "fit your parameters"
        end
      end
    end
  end
end
