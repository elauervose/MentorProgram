require 'spec_helper'

describe "edit category page" do
  let(:admin) { FactoryGirl.create :admin }
  let(:category) { FactoryGirl.create :category }

  describe "authentiction" do
    it "prevents non admins from gaining access" do
      visit edit_category_path(category)
      expect(current_path).to eq root_path
    end
  end

  describe "updating the category" do
    before do
      sign_in(admin)
      visit edit_category_path(category)
    end

    context "with valid information" do
      before do
        fill_in "category_name", with: "Test Category"
        check "category_official"
        click_button "Update Category"
      end

      it "should change the category's name" do
        expect(category.reload.name).to eq "Test Category"
      end
      it "should change the category to be official" do
        expect(category.reload.official?).to be_true
      end
      it "should render the updated category's show page" do
        expect(current_path).to eq category_path(category)
      end
    end

    context "without valid information" do
      before do
        fill_in "category_name", with: ""
        click_button "Update Category"
      end

      it "should not change the category's name" do
        expect(category.reload.name).to_not eq ""
      end
      it "rerenders the form" do
        expect(page).to have_selector "h1", text: "Edit Category"
      end
      it "desplays a message about why category was not updated" do
        expect(page).to have_selector 'div.error_explanation'
      end
    end

  end

end
