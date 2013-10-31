require 'spec_helper'
require 'models/statistics_concern_shared'
extend StatisticsConcernSpecs

describe Category do
  subject(:category) { FactoryGirl.build :category }

  it { should respond_to :name }
  it { should respond_to :mentor_asks }
  it { should respond_to :official }
  it { should be_valid }

  describe "mentor_asks" do
    let(:mentor_ask) { FactoryGirl.create :mentor_ask }

    it "can be added to an mentor_ask" do
      mentor_ask.categories << category
      expect(mentor_ask.categories).to include(category)
    end
  end

  describe "validations" do
    it "should require a name" do
      category.name = ""
      expect(category).to_not be_valid
    end
  end

  describe "official" do
    it "should be set to 'false' by default" do
      category.save
      expect(category.official?).to be_false
    end
  end

  describe "statistics" do
    it_behaves_like Statistics
  end

end
