require 'spec_helper'

describe Answer do
  let(:ask) { FactoryGirl.create :ask }
  subject(:answer) { FactoryGirl.build(:answer, ask: ask) }

  it { should respond_to :name }
  it { should respond_to :email }
  it {should respond_to :ask }
end
