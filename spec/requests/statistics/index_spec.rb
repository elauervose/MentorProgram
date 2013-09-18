require 'spec_helper'

describe "Statistics index" do
  let(:admin) { FactoryGirl.create :admin }
  
  describe "restricting access" do
    it "should redirect non-admins to the homepage" do
      visit statistics_path
      expect(current_path).to eq root_path
    end
  end
  describe "links to specific statistics" do
    before do
     sign_in(admin)
     visit statistics_path
    end

    it "should have a link to location statistics" do
      expect(page).to have_link "Locations"
    end
  end
end  
