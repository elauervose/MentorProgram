require 'spec_helper'

describe Answer do
  let(:ask) { FactoryGirl.create :ask }
  subject(:answer) { FactoryGirl.build(:answer, ask: ask) }

  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :ask }
  it { should be_valid }

  describe "validations" do
    it "should require a name" do
      answer.name = ""
      expect(answer).to_not be_valid
    end
    it "should require an email address" do
      answer.email = ""
      expect(answer).to_not be_valid
    end
    it "should require a valid email address" do
      %w{ not_an_email @invalid.com personATplaceDOTcom
        guy@place.123 }.each do |invalid_email|
        answer.email = invalid_email
        expect(answer).to_not be_valid
        end
    end
  end

end
