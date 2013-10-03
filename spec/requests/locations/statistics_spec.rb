require 'spec_helper'

describe "Location statistics" do
  let(:admin) { FactoryGirl.create :admin }
  let!(:location) { FactoryGirl.create :location }

  before do
    sign_in(admin)
    visit location_path(location)
    @ask = FactoryGirl.create(:mentor_ask,
                              locations: [location],
                              created_at: 1.day.ago)
    @ask.create_answer(FactoryGirl.attributes_for(:answer))
  end

  describe "average response time" do
    it "should be present for a location" do
      visit statistics_locations_path
      expect(page).to have_selector 'p.avg_response_time',
        text: "#{location.average_response_time.to_i} days"
    end
  end

  describe "median response time" do
    it "should be present for a location" do
      visit statistics_locations_path
      expect(page).to have_selector 'p.median_response_time',
        text: "#{location.median_response_time.to_i} days"
    end
  end

  describe "number of requests" do
    specify "total should be present" do
      visit statistics_locations_path
      expect(page).to have_text("1 request")
    end
    specify "answered total should be present" do
      visit statistics_locations_path
      expect(page).to have_text("1 request answered")
    end
  end
end
