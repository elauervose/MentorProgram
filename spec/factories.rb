FactoryGirl.define do
  factory :ask do
    sequence(:name) { |n| "person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    description "I would like to create a website the allows people new
      to tech to find mentors interested in helping them go through
      three 1-2 hour sessions and help them iwth their problems"
    email_updates true
    validated_at Time.now
    locations {[FactoryGirl.create(:location)]}
    meetup_times {[FactoryGirl.create(:meetup_time)]}
  end

  factory :mentor_ask, parent: :ask, class: MentorAsk do
    categories {[FactoryGirl.create(:category)]}
  end

  factory :pair_ask, parent: :ask, class: PairAsk do
  end

  factory :answer do
    sequence(:name) { |n| "answerer #{n}" }
    sequence(:email) { |n| "answerer_#{n}@example.com" }
  end

  factory :location do
    sequence(:name) { |n| "location_#{n}" }
  end

  factory :category do
    sequence(:name) { |n| "category_#{n}" }
    official false
  end

  Days = %w{Monday Tuesday Wednesday Thursday Friday Saturday Sunday}
  Periods = ["Morning", "Afternoon", "Evening"]
  factory :meetup_time do
    sequence(:day) { |n| Days[n % Days.size] }
    sequence(:period) { |n| Periods[n % Periods.size] }
  end

  factory :admin do
    sequence(:email) { |n| "admin_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
  end
end
