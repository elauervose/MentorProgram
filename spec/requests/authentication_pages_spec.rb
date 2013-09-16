require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "sign in" do
    before { visit admin_sign_in_path }

    it { should have_content 'Admin sign in:' }

    describe "with invalid information" do
      before { click_button "Sign in" }
       
      it { should have_content 'Admin sign in:' }
      it { should have_selector 'div.alert.alert-error' }
    end
    describe "with valid information" do
      let(:admin) { FactoryGirl.create :admin }
      before do
        fill_in :email, with: admin.email
        fill_in :password, with: admin.password
        click_button "Sign in"
      end
      it { should have_content 'Admin Home' }
      it { should have_link('Sign out', href: admin_sign_out_path) }
      describe "and then signing out" do
        before { click_link "Sign out" }

        it { should have_content('Admin sign in') }
      end
    end
  end

  describe "authorization" do
    describe "when not signed in" do
      before { visit admin_home_path }
      it { should_not have_content "Admin" }
      it { should have_selector 'h1', text: 'Mentor Program' }
    end
  end

end
