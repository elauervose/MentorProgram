require 'spec_helper'

describe PairAsk do
  
  subject(:pair_ask) { FactoryGirl.build :pair_ask }

  its(:type) { should eq "PairAsk" } 
  it { should be_valid }

end
