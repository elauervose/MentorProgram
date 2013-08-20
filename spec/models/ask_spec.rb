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
    describe "of association" do
      let(:location) { FactoryGirl.create :location }
      let(:meetup) { FactoryGirl.create :meetup_time }
      let(:category) { FactoryGirl.create :category }
      before do
        @ask = Ask.new(name: "test", email: "test@example.com",
                       description: "text")
      end
      describe "on locations" do
        it "should require at least one location" do
          @ask.meetup_times << meetup
          @ask.categories << category
          expect(@ask).to_not be_valid
        end
      end
      describe "on meetup times" do
        it "should erquire at least one meetup time" do
          @ask.categories << category
          @ask.locations << location
          expect(@ask).to_not be_valid
        end
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

  describe "scopes" do
    before { ask.save }
    describe "'with_location'" do
      it "should be included when Asks scoped to its location" do
        expect(Ask.with_location(ask.locations.first)).to include ask
      end
      it "should not be included when Asks scoped to a different location" do
        other_location = FactoryGirl.create :location
        expect(Ask.with_location(other_location)).to_not include ask
      end
    end
    describe "'with_category'" do
      it "should be included when Asks scoped to its category" do
        expect(Ask.with_category(ask.categories.first)).to include ask
      end
      it "should not be included when Asks scoped to a different category" do
        other_category = FactoryGirl.create :category
        expect(Ask.with_category(other_category)).to_not include ask
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
      context "when time is 'Any'" do
        it "should be included no matter what time Asks is scoped to" do
          meetup = FactoryGirl.create :meetup_time, period: "Any"
          ask.meetup_times.delete_all
          ask.meetup_times << meetup 
          ask.save
          expect(Ask.with_time("Morning")).to include ask
        end
      end
    end
    describe "'with_filters'" do
      let(:location) { ask.locations.first }
      let(:category) { ask.categories.first }
      let(:day) { ask.meetup_times.first.day }
      let(:time) { ask.meetup_times.first.period }

      it "should be included when Asks scoped to at least 1 of its attr" do
        expect(Ask.with_filters(location,"","","")).to include ask
      end
      it "should be included when Asks scopred to all its attr" do
        expect(Ask.with_filters(location, category, day, time)).to include ask
      end
    end
  end
end
