require 'spec_helper'

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
    context "for mentor asks" do
      describe "average response" do
        it "returns difference in ask and answer creations times for one ask" do
          ask = FactoryGirl.create(:mentor_ask,
                                   categories: [category], created_at: 1.day.ago)
          ask.create_answer(FactoryGirl.attributes_for(:answer))
          expect(category.average_response_time).to be_within(0.01).of(1)
        end
        it "returns correct value for a set of asks" do
          3.times do
            ask = FactoryGirl.create(:mentor_ask,
                                     categories: [category],
                                     created_at: 1.day.ago)
            ask.create_answer(FactoryGirl.attributes_for :answer)
          end
          expect(category.average_response_time).to be_within(0.01).of(1)
        end
      end
      describe "median response" do
        it "returns difference in ask and answer creation times for one ask" do
          ask = FactoryGirl.create(:mentor_ask,
                                   categories: [category], created_at: 1.day.ago)
          ask.create_answer(FactoryGirl.attributes_for(:answer))
          expect(category.median_response_time).to be_within(0.01).of(1)
        end
        it "returns correct value for a set of asks" do
          3.times do
            ask = FactoryGirl.create(:mentor_ask,
                                     categories: [category],
                                     created_at: 1.day.ago)
            ask.create_answer(FactoryGirl.attributes_for :answer)
          end
          expect(category.median_response_time).to be_within(0.01).of(1)
        end
      end
    end
  end
end
