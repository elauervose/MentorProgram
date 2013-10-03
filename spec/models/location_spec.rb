require 'spec_helper'

describe Location do
  subject(:location) { FactoryGirl.build :location }

  it { should respond_to :name }
  it { should respond_to :asks }

  describe "validations" do
    describe "on name" do
      let(:no_name_location) { FactoryGirl.build(:location, name: "") }
      it "is not valid without a name" do
        expect(no_name_location).to_not be_valid
      end
      it "is not valid with too long a name" do
        too_long_name_location = FactoryGirl.build(:location, name: "a"*51)
        expect(too_long_name_location).to_not be_valid
      end
      it "does not create a new location without a name" do
        expect { no_name_location.save }.to_not change(Location, :count)
      end
    end
  end
  describe "asks" do
    let(:ask) { FactoryGirl.create :ask }
    it "can be added" do
      ask.locations << location
      expect(location.asks).to include(ask)
    end
  end

  describe "statistics" do
    let(:location) { FactoryGirl.create :location }
    context "for mentor asks" do
      describe "average response" do
        it "returns difference in ask and answer creations times for one ask" do
          ask = FactoryGirl.create(:mentor_ask,
                                   locations: [location], created_at: 1.day.ago)
          ask.create_answer(FactoryGirl.attributes_for(:answer))
          expect(location.average_response_time).to be_within(0.01).of(1)
        end
        it "returns correct value for a set of asks" do
          3.times do
            ask = FactoryGirl.create(:mentor_ask,
                                     locations: [location],
                                     created_at: 1.day.ago)
            ask.create_answer(FactoryGirl.attributes_for :answer)
          end
          expect(location.average_response_time).to be_within(0.01).of(1)
        end
      end
      describe "median response" do
        it "returns difference in ask and answer creation times for one ask" do
          ask = FactoryGirl.create(:mentor_ask,
                                   locations: [location], created_at: 1.day.ago)
          ask.create_answer(FactoryGirl.attributes_for(:answer))
          expect(location.median_response_time).to be_within(0.01).of(1)
        end
        it "returns correct value for a set of asks" do
          3.times do
            ask = FactoryGirl.create(:mentor_ask,
                                     locations: [location],
                                     created_at: 1.day.ago)
            ask.create_answer(FactoryGirl.attributes_for :answer)
          end
          expect(location.median_response_time).to be_within(0.01).of(1)
        end
      end
    end
  end

end
