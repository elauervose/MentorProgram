require 'spec_helper'

describe Category do
  subject(:category) { FactoryGirl.build :category }

  it { should respond_to :name }
  it { should respond_to :asks }
  it { should be_valid }

  describe "asks" do
    let(:ask) { FactoryGirl.create :ask }

    it "can be added to an ask" do
      ask.categories << category
      expect(ask.categories).to include(category)
    end
  end

  describe "validations" do
    it "should require a name" do
      category.name = ""
      expect(category).to_not be_valid
    end
  end
end
