require 'spec_helper'

describe "Navigation bar" do
  context "as an administrator" do
    let(:admin) { FactoryGirl.create :admin }
    before do
      sign_in(admin)
      visit root_path
    end
    
    it "should have a link to sign out" do
      expect(page).to have_link "Sign out", href: admin_sign_out_path
    end
    it "should have a link to admin homepage" do
      expect(page).to have_link "Admin Home", href: admin_home_path
    end
  end

  context "as a normal user" do
    before { visit root_path }

    it "should not have a link to the admin homepage" do
      expect(page).to_not have_link "Admin Home", href: admin_home_path
    end
  end

end
