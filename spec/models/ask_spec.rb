require 'spec_helper'

describe Ask do
  subject(:ask) { FactoryGirl.build :ask }
  let(:answer) { FactoryGirl.attributes_for(:answer, ask: ask) }

  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :description }
  it { should respond_to :email_updates }
  it { should respond_to :answered }
  it { should respond_to :answer }
  it { should respond_to :locations }
  it { should respond_to :meetup_times }
  it { should respond_to :token }
  it { should respond_to :validated_at }
  it { should respond_to :validated? }
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
    describe "of association" do
      let(:location) { FactoryGirl.create :location }
      let(:meetup) { FactoryGirl.create :meetup_time }
      before do
        @ask = Ask.new(name: "test", email: "test@example.com",
                       description: "text")
      end
      describe "on locations" do
        it "should require at least one location" do
          @ask.meetup_times << meetup
          expect(@ask).to_not be_valid
        end
      end
      describe "on meetup times" do
        it "should erquire at least one meetup time" do
          @ask.locations << location
          expect(@ask).to_not be_valid
        end
      end
    end
  end

  describe "token" do
    before { ask.save! }
    
    it "should be created on save" do
      secret_token = Rails.application.config.secret_key_base
      expected_value = Digest::SHA1.hexdigest(secret_token + ask.email +
                                              ask.created_at.to_s)
      expect(ask.token).to eq expected_value
    end
  end

  describe "validating request" do
    before { ask.save! }

    it "should not be validated after save" do
      expect(ask.validated?).to be_false
    end
    it "should be validated when correct hash supplied" do
      secret_token = Rails.application.config.secret_key_base
      validated_ask = Ask.validate_request(ask.token)
      expect(validated_ask).to eq ask
    end
    it "should not be validated when incorrect hash supplied" do
      invalid_token = Digest::SHA1.hexdigest("invalid token")
      Ask.validate_request(invalid_token)
      expect(ask.validated?).to be_false
    end
  end

  describe "locations" do
    let(:location) { FactoryGirl.create :location }
    it "should add a location" do
      ask.locations << location
      expect(ask.locations).to include(location)
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
  end

  describe "answered_requests_with" do
    let(:location) { FactoryGirl.create(:location) }

    before { ask.save! }

    it "should return an array of asks with the provide assosciation" do
      ask.locations = [location]
      ask.create_answer(answer)
      expect(Ask.answered_requests_with(location)).to include(ask)
    end
    it "should return an empty array with no asks have the assosciation" do
      ask.create_answer(answer)
      expect(Ask.answered_requests_with(location)).to eq []
    end
  end

  describe "scopes" do
    before { ask.save }
    describe "default scope" do
      it "should order asks by descending creation time (newest first)" do
        other_ask = FactoryGirl.create :ask
        expect(Ask.all.first.name).to eq(other_ask.name)
      end
    end
    describe "'with_location'" do
      it "should be included when Asks scoped to its location" do
        expect(Ask.with_location(ask.locations.first)).to include ask
      end
      it "should not be included when Asks scoped to a different location" do
        other_location = FactoryGirl.create :location
        expect(Ask.with_location(other_location)).to_not include ask
      end
    end
    describe "'with_day'" do
      it "should be included when Asks scoped to its day" do
        expect(Ask.with_day(ask.meetup_times.first.day)).to include ask
      end
      it "should not be included when Asks scoped to a different day" do
        other_meetup = FactoryGirl.create :meetup_time
        expect(Ask.with_day(other_meetup)).to_not include ask
      end
    end
    describe "'with_time'" do
      it "should be included when Asks scoped to its time" do
        expect(Ask.with_time(ask.meetup_times.first.period)).to include ask
      end
      it "should not be included when Asks scoped to a different time" do
        other_meetup = FactoryGirl.create :meetup_time
        expect(Ask.with_time(other_meetup)).to_not include ask
      end
    end
    describe "'with_filters'" do
      let(:location) { ask.locations.first }
      let(:day) { ask.meetup_times.first.day }
      let(:time) { ask.meetup_times.first.period }

      it "should be included when Asks scoped to at least 1 of its attr" do
        expect(Ask.with_filters(location,"","")).to include ask
      end
      it "should be included when Asks scopred to all its attr" do
        expect(Ask.with_filters(location, day, time)).to include ask
      end
    end
  end
end
