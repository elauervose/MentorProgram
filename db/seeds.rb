# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

days = %w{Monday Tuesday Wednesday Thursday Friday Saturday Sunday }
periods = ["Morning", "Afternoon", "Evening"]
locations = ["Inner SE", "Inner NE", "Downtown", "Old Town & The Pearl",
  "Inner NW", "Inner SW"]
categories = ["Basic Web", "HTML/CSS", "Github/Heroku/Command Line",
  "Beginning JavaScript", "Beginning Ruby", "Sinatra", "APIs"]

#create meetup_times
days.each do |day|
  periods.each do |period|
    MeetupTime.create(day: day, period: period)
  end
end

locations.each { |location| Location.create(name: location) }
categories.each { |category| Category.create(name: category, official: true) }

