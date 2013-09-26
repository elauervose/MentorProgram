namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    NumberMentorRequests = 50
    NumberMentorAnswers = 15
    NumberPairRequests = 20
    NumberPairAnswers = 8

    MaxLocationsPerRequest = 5
    MaxCategoriesPerRequest = 3
    MaxTimesPerRequest = 21

    DatabaseCleaner.clean_with :truncation,
        { except: %w[locations categories meetup_times] }

    create_admin

    NumberMentorRequests.times do |n|
      request = create_mentor_request
      add_locations(request)
      add_categories(request)
      add_meetup_times(request)
      request.save!
      answer_request(request) unless n > NumberMentorAnswers + 1
    end

    NumberPairRequests.times do |n|
      request = create_pair_request
      add_locations(request)
      add_meetup_times(request)
      request.save!
      answer_request(request) unless n > NumberPairAnswers + 1
    end

  end

  def create_admin
    Admin.create!(email: "test_admin@example.com", password: 'password',
                  password_confirmation: 'password')
  end
  
  def create_mentor_request
    MentorAsk.new(name: Faker::Name.name,
                  email: Faker::Internet.safe_email,
                  description: Faker::Lorem.sentence(20)
                  )
  end

  def create_pair_request
    PairAsk.new(name: Faker::Name.name,
                email: Faker::Internet.safe_email,
                description: Faker::Lorem.sentence(20)
               )
  end

  def answer_request(request)
    Ask.find(request.id).create_answer(name: Faker::Name.name,
                                       email: Faker::Internet.safe_email
                                      )
  end

  def add_locations(request)
    random_id_list(Location.count, MaxLocationsPerRequest).each do |location|
      request.locations << Location.find(location)
    end
  end

  def add_categories(request)
    random_id_list(Category.count, MaxCategoriesPerRequest).each do |category|
      request.categories << Category.find(category)
    end
  end

  def add_meetup_times(request)
    random_id_list(MeetupTime.count, MaxTimesPerRequest).each do |time|
      request.meetup_times << MeetupTime.find(time)
    end
  end

  def random_id_list(max_id, max_ids_to_return)
    random_ids = [*1..max_id].shuffle
    number_of_ids = rand(1..max_ids_to_return)
    random_ids.take(number_of_ids)
  end

end

