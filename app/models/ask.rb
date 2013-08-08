class Ask < ActiveRecord::Base
  has_one :answer
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :meetup_times
 end
