class Ask < ActiveRecord::Base
  has_one :answer
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :meetup_times
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 300 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
    length: { maximum: 256}
  validates :locations, presence: true
  validates :meetup_times, presence: true

  default_scope { order "created_at DESC" }
  scope :not_answered, -> { where answered: false }
  scope :with_location, ->(location) do
    if location.blank?
      all
    else
      joins(:locations).where('locations.id' => location)
    end
  end
  scope :with_day, ->(day) do
    if day.blank?
      all
    else
      joins(:meetup_times).where('meetup_times.day' => day).uniq
    end
  end
  scope :with_time, ->(time) do
    if time.blank?
      all
    else
      joins(:meetup_times).
        where('meetup_times.period' => time).uniq
    end
  end

  scope :with_filters, ->(location, day, time) do
    with_location(location).with_day(day).with_time(time)
  end

 end
