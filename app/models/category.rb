class Category < ActiveRecord::Base
  include Statistics
  has_and_belongs_to_many :mentor_asks, association_foreign_key: 'ask_id'
  validates :name, presence: true

  scope :admin_created, -> { where official: true }

  def average_response_time
    answered_requests = MentorAsk.includes(:answer).
      where(answered: true).with_category(self.id)
    average_response_in_days(answered_requests)
  end

  def median_response_time
    answered_requests = MentorAsk.includes(:answer).
      where(answered: true).with_category(self.id)
    median_response_in_days(answered_requests)
  end

end
