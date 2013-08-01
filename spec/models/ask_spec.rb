require 'spec_helper'

describe Ask do
  subject(:ask) { FactoryGirl.build :ask }

  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :description }
  it { should respond_to :email_updates }
  it { should respond_to :answered }
  it { should respond_to :answer }
  it { should respond_to :locations }

  describe "locations" do
    let(:location) { FactoryGirl.create :location }
    it "should be add a location" do
      ask.locations << location
      expect(ask.locations).to include(location)
    end
  end

end
