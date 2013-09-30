require 'spec_helper'

describe "Edit Mentor Ask" do
  let(:mentor_ask) { FactoryGirl.create(:mentor_ask,
                                        meetup_times: [MeetupTime.first]) }
  before :all do
    days = %w{Monday Tuesday Wednesday Thursday Friday Saturday Sunday }
    periods = ["Morning", "Afternoon", "Evening"]
    days.each do |day|
      periods.each do |period|
        MeetupTime.create(day: day, period: period)
      end
    end
  end

  describe "on loading the form" do
    context "locations checkboxes" do
      it "has the locations of the request selected" do
        visit edit_mentor_ask_path(mentor_ask)
        selected_location_box =
          find "#mentor_ask_locations_#{mentor_ask.locations.first.id}"
        expect(selected_location_box.checked?).to be_true
      end
      it "does not have selected locations not in the request" do
        unselected_location = FactoryGirl.create :location
        visit edit_mentor_ask_path(mentor_ask)
        unselected_location_box =
          find "#mentor_ask_locations_#{unselected_location.id}"
        expect(unselected_location_box.checked?).to be_false
      end
    end
    context "meetup times checkboxes" do
      it "have the meetup times of the request selected" do
        visit edit_mentor_ask_path(mentor_ask)
        selected_meetup_time_box =
          find "#mentor_ask_meetup_times_#{mentor_ask.meetup_times.first.id}"
        expect(selected_meetup_time_box.checked?).to be_true
      end
      it "does not have meetup times not in the request selected" do
        unselected_meetup_time = MeetupTime.last
        visit edit_mentor_ask_path(mentor_ask)
        unselected_meetup_time_box = 
          find "#mentor_ask_meetup_times_#{unselected_meetup_time.id}"
        expect(unselected_meetup_time_box.checked?).to be_false
      end
    end
    context "categories checkboxes" do
      it "have the categories of the request selected" do
        official_category = FactoryGirl.create(:category, official: true)
        mentor_ask.categories << official_category
        visit edit_mentor_ask_path(mentor_ask)
        selected_category_box =
          find "#mentor_ask_categories_#{official_category.id}"
        expect(selected_category_box.checked?).to be_true
      end
      it "does not have category not in the request selected" do
        unselected_category = FactoryGirl.create(:category, official: true)
        visit edit_mentor_ask_path(mentor_ask)
        unselected_category_box = 
          find "#mentor_ask_categories_#{unselected_category.id}"
        expect(unselected_category_box.checked?).to be_false
      end
      context "with user-created category" do
        it "has a checkbox with the user-created category selected" do
          visit edit_mentor_ask_path(mentor_ask)
          selected_category_box =
            find "#mentor_ask_categories_#{mentor_ask.categories.first.id}"
          expect(selected_category_box.checked?).to be_true
        end
      end
    end
  end
end
