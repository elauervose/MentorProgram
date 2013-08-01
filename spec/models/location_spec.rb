require 'spec_helper'

describe Location do
  subject(:location) { FactoryGirl.build :location }

  it { should respond_to :name }
  it { should respond_to :asks }

  describe "asks" do
    let(:ask) { FactoryGirl.create :ask }
    it "can be added" do
      ask.locations << location
      expect(location.asks).to include(ask)
    end
  end

end
