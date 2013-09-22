require 'spec_helper'

describe "new category page" do
  let(:admin) { FactoryGirl.create :admin }

  describe "authentication" do
    it "should redirect non admins to the homepage" do
      visit new_category_path
      expect(current_path).to eq root_path
    end
  end

  describe "creating a new category" do
    before do
      sign_in(admin)
      visit new_category_path
    end

    context "with valid information" do
      before do
      fill_in "Name", with: "Test Category"
      check "category_official"
      click_button "Create New Category"
      end

      it "should create a new category" do
        expect(Category.find_by(name: "Test Category")).to_not be_nil
      end
      it "should redirect to the category index" do
        expect(current_path).to eq categories_path
      end
    end

    context "with invalid information" do

      it "should not create a new category" do
        expect { click_button "Create New Category" }.
          to_not change(Category, :count)
      end
      it "re-renders the form" do
        click_button "Create New Category"
        expect(page).to have_selector 'h1', text: "Create New Category"
      end
      it "displays a message about why information was not valid" do
        click_button "Create New Category"
        expect(page).to have_selector 'div.error_explanation'
      end
    end

  end

end
