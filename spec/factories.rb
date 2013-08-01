FactoryGirl.define do
  factory :ask do
    sequence(:name) { |n| "person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    description "I would like to create a website the allows people new
      to tech to find mentors interested in helping them go through
      three 1-2 hour sessions and help them iwth their problems"
    email_updates true
    answered false
  end
end
