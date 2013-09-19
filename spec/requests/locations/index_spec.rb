require 'spec_helper'

describe "Locations index" do
  let(:admin) { FactoryGirl.create(:admin) }

  describe "Authorization" do
    before { visit locations_path }

    it "should redirect non-admins to the homepage" do
      expect(current_path).to eq root_path
    end
  end

  describe "table of locations" do
    let!(:location) { FactoryGirl.create :location }
    before do
      sign_in(admin)
      visit locations_path
    end

    it "contains a row for a location" do
      expect(page).to have_selector "tr#location_#{location.id}"
    end
    it "has a link to create a new location" do
      expect(page).to have_link "Create new location"
    end
    context "deleting a location" do
      specify "there should be a link to delete the location" do
        expect(page).to have_link "Delete", href: location_path(location)
      end
      it "should remove the location when the link is clicked", js: true do
        click_link "Delete", href: location_path(location)
        page.driver.browser.switch_to.alert.accept
        expect(current_path).to eq locations_path
        expect(Location.find_by(id: location.id)).to be_nil
      end
    end
    context "editing a location" do
      specify "there should be a link to edit the location" do
        expect(page).to have_link "Edit", href: edit_location_path(location)
      end
      it "should take the admin to edit page for the specified location" do
        click_link "Edit", href: edit_location_path(location)
        expect(page).to have_selector 'h1', text: "Edit Location"
      end
    end
  end
end

