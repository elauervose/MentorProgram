require 'spec_helper'

describe "Location statistics" do
  let(:admin) { FactoryGirl.create :admin }
  let!(:location) { FactoryGirl.create :location }

  before do
    sign_in(admin)
    visit location_path(location)
  end

  describe "average response time" do
    before do
      @ask = FactoryGirl.create(:mentor_ask,
                                locations: [location],
                                created_at: 1.day.ago)
      @ask.create_answer(FactoryGirl.attributes_for(:answer))
    end
    it "should be present for a location" do
      visit statistics_locations_path
      expect(page).to have_text "#{location.average_response_time.to_i} days"
    end
  end
  describe "number of requests" do
    specify "total should be present" do
      ask = FactoryGirl.create(:mentor_ask, locations: [location])
      ask.create_answer(FactoryGirl.attributes_for(:answer))
      visit statistics_locations_path
      expect(page).to have_text("1 request")
    end
    specify "answered total should be present" do
      ask = FactoryGirl.create(:mentor_ask, locations: [location])
      ask.create_answer(FactoryGirl.attributes_for(:answer))
      visit statistics_locations_path
      expect(page).to have_text("1 request answered")
    end
  end
end
