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
  it { should respond_to :categories }
  it { should respond_to :meetup_times }
  it { should be_valid }

  describe "validations" do
    describe "on name" do
      it "should prevent a blank name" do
        ask.name = ""
        expect(ask).to_not be_valid
      end
      it "should prevent too long a name" do
        ask.name = "a"*51
        expect(ask).to_not be_valid
      end
    end
    describe "on email" do
      it "should prevent a blank email address" do
        ask.email = ""
        expect(ask).to_not be_valid
      end
      it "should prevent an valid email address" do
        %w{ not_an_email @invalid.com personATplaceDOTcom
          guy@place.123 }.each do |invalid_email|
          ask.email = invalid_email
          expect(ask).to_not be_valid
          end
      end
      it "should prevent too long an email address" do
        ask.email = "a"*245 + "@example.com"
        expect(ask).to_not be_valid
      end
    end
    describe "on desciption" do
      it "should prevent an empty description" do
        ask.description = ""
        expect(ask).to_not be_valid
      end
      it "should prevent too long a description" do
        ask.description = "a"*301
        expect(ask).to_not be_valid
      end
    end
  end

  describe "locations" do
    let(:location) { FactoryGirl.create :location }
    it "should add a location" do
      ask.locations << location
      expect(ask.locations).to include(location)
    end
  end

  describe "categories" do
    let(:category) { FactoryGirl.create :category }

    it "should add the category ask" do
      ask.categories  << category
      expect(ask.categories).to include(category)
    end
  end

  describe "meetup_times" do
    let(:meetup) { FactoryGirl.create :meetup_time }

    it "should add a meetup time" do
      ask.meetup_times << meetup
      expect(ask.meetup_times).to include(meetup)
    end
  end

  describe "when answered" do
    let(:answer) { FactoryGirl.attributes_for(:answer, ask: ask) }

    before do
      ask.save!
      ask.create_answer(answer)
    end

    it "should have an answer" do
      expect(ask.answer).to_not be_nil
    end
    it "should be answered" do
      ask.reload
      expect(ask.answered?).to eq(true)
    end

    it "should result in an introductory email being sent" do
      intro_email = ActionMailer::Base.deliveries.last
      expect(intro_email.to).to include(ask.email)
      expect(intro_email.to).to include(ask.answer.email)
    end
  end
end
