require 'spec_helper'

describe "edit location" do
  let(:admin) { FactoryGirl.create :admin }
  let(:location) { FactoryGirl.create :location }
  before do
    sign_in(admin)
    visit edit_location_path(location)
  end

  context "with valid information" do
    before do
      fill_in "location_name", with: "Test Location"
      click_button "Update Location"
    end

    it "should change the location's name" do
      expect(location.reload.name).to eq "Test Location"
    end
    it "should redirect to the location's show page" do
      expect(page).to have_selector "h1", text: "Test Location"
    end
  end
  
  context "with invalid information" do
    before do
      fill_in 'location_name', with: ""
      click_button "Update Location"
    end

    it "should not change the location's name" do
       expect(location.reload.name).to_not eq "Test Location"
    end
    it "rerenders the form" do
      expect(page).to have_selector "h1", text: "Edit Location"
    end
    it "displays a message about why location was not updated" do
      expect(page).to have_selector 'div.error_explanation'
    end
  end


end
