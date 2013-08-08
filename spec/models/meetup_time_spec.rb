require 'spec_helper'

describe MeetupTime do
  subject(:meetup) { FactoryGirl.build :meetup_time }

  it { should respond_to :day }
  it { should respond_to :period }

  describe "asks" do
    let(:ask) { FactoryGirl.create :ask }

    it "should be able to be added to an ask" do
      ask.meetup_times << meetup
      expect(meetup.asks).to include(ask)
    end
  end
end
