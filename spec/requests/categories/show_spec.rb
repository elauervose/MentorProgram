require 'spec_helper'

describe "show category" do
  let(:admin) { FactoryGirl.create :admin }
  let(:category) { FactoryGirl.create :category }

  describe "authentication" do
    it "prevents access if not a logged in admin" do
      visit category_path(category)
      expect(current_path).to eq root_path
    end
  end

  describe "visiting as an admin" do
    before do
      sign_in(admin)
      visit category_path(category)
    end

    it "should show the category" do
      expect(page).to have_selector 'h1', text: category.name
    end
  end

end
