require 'spec_helper'

describe PairAsk do
  
  subject(:pair_ask) { FactoryGirl.build :pair_ask }

  its(:type) { should eq "PairAsk" } 
  it { should be_valid }

  describe "when answered" do
    let(:answer) { FactoryGirl.attributes_for(:answer, ask: pair_ask) }

    before do
      pair_ask.save!
      pair_ask.create_answer(answer)
    end

    it "should have an answer" do
      expect(pair_ask.answer).to_not be_nil
    end
    it "should be answered" do
      pair_ask.reload
      expect(pair_ask.answered?).to eq(true)
    end

    it "should result in introductory email being sent to pair requester" do
      intro_email = ActionMailer::Base.deliveries.last
      expect(intro_email.to).to include(pair_ask.email)
    end
  end

end
