require 'spec_helper'

describe MentorAsk do
  subject(:mentor_ask) { FactoryGirl.build :mentor_ask }

  its(:type) { should eq "MentorAsk" } 
  it { should be_valid }

  describe "categories" do
    let(:category) { FactoryGirl.create :category }

    it "should add the category mentor_ask" do
      mentor_ask.categories  << category
      expect(mentor_ask.categories).to include(category)
    end
  end

  describe "when answered" do
    let(:answer) { FactoryGirl.attributes_for(:answer, mentor_ask: mentor_ask) }

    before do
      mentor_ask.save!
      mentor_ask.create_answer(answer)
    end

    it "should have an answer" do
      expect(mentor_ask.answer).to_not be_nil
    end
    it "should be answered" do
      mentor_ask.reload
      expect(mentor_ask.answered?).to eq(true)
    end

    it "should result in introductory email being sent to mentee" do
      intro_email = ActionMailer::Base.deliveries.last
      expect(intro_email.to).to include(mentor_ask.email)
    end
  end

  describe "scopes" do
    before { mentor_ask.save }
    describe "'with_category'" do
      it "should be included when MentorAsks scoped to its category" do
        expect(MentorAsk.with_category(mentor_ask.categories.first)).
          to include mentor_ask
      end
      it "should not be included when MentorAsks scoped to a
       different category" do
        other_category = FactoryGirl.create :category
        expect(MentorAsk.with_category(other_category)).
          to_not include mentor_ask
      end
    end
    describe "'with_filters'" do
      let(:location) { mentor_ask.locations.first }
      let(:category) { mentor_ask.categories.first }
      let(:day) { mentor_ask.meetup_times.first.day }
      let(:time) { mentor_ask.meetup_times.first.period }

      it "should be included when MentorAsks scoped to at
        least 1 of its attr" do
        expect(MentorAsk.with_filters(location,"","","")).to include mentor_ask
      end
      it "should be included when MentorAsks scopred to all its attr" do
        expect(MentorAsk.with_filters(location, category, day, time)).
          to include mentor_ask
      end
    end
  end
end
