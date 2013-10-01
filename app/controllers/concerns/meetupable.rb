module Meetupable

  def add_meetup_times(meetups)
    if meetups
      meetups.each { |meetup| @ask.meetup_times << MeetupTime.find(meetup) }
    end
  end

  def update_meetup_times(meetups)
    if meetups
      meetup_time_ids = meetups.collect { |meetup| meetup.to_i }
      @ask.meetup_times = MeetupTime.find(meetup_time_ids)
    else
      @ask.meetup_times.clear
    end
  end
end
