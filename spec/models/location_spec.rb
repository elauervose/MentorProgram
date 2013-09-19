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

end
