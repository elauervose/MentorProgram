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

  end
end
