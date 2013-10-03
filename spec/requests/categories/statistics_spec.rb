require 'spec_helper'

describe "Category statistics" do
  let(:admin) { FactoryGirl.create :admin }
  let!(:category) { FactoryGirl.create :category }

  before do
    sign_in(admin)
    visit category_path(category)
    @ask = FactoryGirl.create(:mentor_ask,
                              categories: [category],
                              created_at: 1.day.ago)
    @ask.create_answer(FactoryGirl.attributes_for(:answer))
  end

  describe "average response time" do
    it "should be present for a category" do
      visit statistics_categories_path
      expect(page).to have_selector 'p.avg_response_time',
        text: "#{category.average_response_time.to_i} days"
    end
  end

  describe "median response time" do
    it "should be present for a category" do
      visit statistics_categories_path
      expect(page).to have_selector 'p.median_response_time',
        text: "#{category.median_response_time.to_i} days"
    end
  end

  describe "number of requests" do
    specify "total should be present" do
      visit statistics_categories_path
      expect(page).to have_text("1 request")
    end
    specify "answered total should be present" do
      visit statistics_categories_path
      expect(page).to have_text("1 request answered")
    end
  end
end
