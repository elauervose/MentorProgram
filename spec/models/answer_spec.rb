require 'spec_helper'

describe Answer do
  let(:ask) { FactoryGirl.create :ask }
  subject(:answer) { FactoryGirl.build(:answer, ask: ask) }

  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :ask }
  it { should respond_to :disclaimer }
  it { should be_valid }

  describe "validations" do
    describe "on name" do
      it "prevents a blank name" do
        answer.name = ""
        expect(answer).to_not be_valid
      end
      it "prevents too long a name" do
        answer.name = "a"*51
        expect(answer).to_not be_valid
      end
    end
    describe "on email" do
      it "prevents a blank email address" do
        answer.email = ""
        expect(answer).to_not be_valid
      end
      it "prevents an invalid email address" do
        %w{ not_an_email @invalid.com personATplaceDOTcom
          guy@place.123 }.each do |invalid_email|
          answer.email = invalid_email
          expect(answer).to_not be_valid
          end
      end
      it "prevents too long an email address" do
        answer.email = "a"*245 + "@example.com"
        expect(answer).to_not be_valid
      end
    end
  end
  describe "agreeing to site disclaimer" do
    it "should require the user to agree to content of disclaimer" do
      ask.disclaimer = false
      expect(ask).to_not be_valid
    end
  end
  describe "on answer creation" do
    before { answer.save }

    it "the associated ask should be answered" do
      expect(answer.ask.answered?).to be_true
    end
    context "for mentor request" do
      let(:ask) { FactoryGirl.create(:mentor_ask) }

      it "should send an email to introduce the mentee to the mentor" do
        intro_email = ActionMailer::Base.deliveries[-2]
        expect(intro_email.to).to include(answer.email)
      end
    end
    context "for pairing request" do
      let(:ask) { FactoryGirl.create(:pair_ask) }

      it "should send an email to introduce the pair asker to the answerer" do
        intro_email = ActionMailer::Base.deliveries[-2]
        expect(intro_email.to).to include(answer.email)
      end
    end
  end

end
