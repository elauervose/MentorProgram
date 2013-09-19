require "spec_helper"

describe "new location page" do
  let(:admin) { FactoryGirl.create :admin }
  before do
    sign_in(admin)
    visit new_location_path
  end

  context "with valid information" do
    before do
      fill_in "Name", with: "Test Location"
      click_button "Create New Location"
    end

    it "should create a new location" do
      expect(Location.find_by(name: "Test Location")).to_not be_nil
    end
    it "should redirect to the locations index" do
      expect(page).to have_selector "h1", text: "Locations Index"
    end
  end

  context "with invalid information" do

    it "should not create a new location" do
      expect { click_button "Create New Location" }.
        to_not change(Location, :count)
    end
    it "rerenders the form" do
      click_button "Create New Location"
      expect(page).to have_selector "h1", text: "New Location"
    end
    it "displays a message about why information was not valid" do
      click_button "Create New Location"
      expect(page).to have_selector 'div.error_explanation'
    end
  end

end


