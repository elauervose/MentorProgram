class Ask < ActiveRecord::Base
  has_one :answer
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :categories
  accepts_nested_attributes_for :categories
  has_and_belongs_to_many :meetup_times
  validates :name, :description, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
 end
