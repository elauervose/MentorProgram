require 'spec_helper'

describe "categories index page" do
  let(:admin) { FactoryGirl.create :admin }

  describe "authorization" do
    before { visit categories_path }

    it "redirect non-admins to the homepage" do
      expect(current_path).to eq root_path
    end
  end

  describe "table of categories" do
    let!(:category) { FactoryGirl.create :category }
    before do
      sign_in(admin)
      visit categories_path
    end

    it "contains a row for a category" do
      expect(page).to have_selector "tr#category_#{category.id}"
    end
    it "contains a link to create a new category" do
      expect(page).to have_link "Create new category"
    end

    describe "category stats" do
      let(:ask) { FactoryGirl.create :mentor_ask }
      before do
        ask.categories << category
        visit categories_path
      end

      it "contains the number of asks made with category" do
        expect(page).to have_selector "tr#category_#{category.id} td",
          text: category.mentor_asks.count
      end
      it "contains the number of asks answered with a category" do
        expect(page).to have_selector "tr#category_#{category.id} td",
          text: category.mentor_asks.where(answered: true).count
      end
    end
      
    context "deleting a category" do
      specify "there should be a link to delete the category" do
        expect(page).to have_link "Delete", href: category_path(category)
      end
      it "should remove the category when the link is clicked", js: true do
        click_link "Delete", href: category_path(category)
        page.driver.browser.switch_to.alert.accept
        expect(current_path).to eq categories_path
        expect(Category.find_by(id: category.id)).to be_nil
      end
    end
    context "editing a category" do
      specify "there should be a link to edit the category" do
        expect(page).to have_link "Edit", href: edit_category_path(category)
      end
      it "should take the admin to edit page for the specified category" do
        click_link "Edit", href: edit_category_path(category)
        expect(page).to have_selector 'h1', text: "Edit Category"
      end
    end

  end
end
