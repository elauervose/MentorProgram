class Ask < ActiveRecord::Base
  include Emailable
  has_one :answer
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :meetup_times
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 300 }
  validates :locations, presence: true
  validates :meetup_times, presence: true

  default_scope { order "created_at DESC" }

  scope :not_answered, -> { where answered: false }

  scope :with_location, ->(location) do
    return all if location.blank?
    joins(:locations).where('locations.id' => location)
  end

  scope :with_day, ->(day) do
    return all if day.blank?
    joins(:meetup_times).where('meetup_times.day' => day).uniq
  end

  scope :with_time, ->(time) do
    return all if time.blank?
    joins(:meetup_times).where('meetup_times.period' => time).uniq
  end

  scope :with_filters, ->(location, day, time) do
    with_location(location).with_day(day).with_time(time)
  end

 end
