class Location < ActiveRecord::Base
  include Statistics
  has_and_belongs_to_many :asks

  validates :name, presence: true, length: { maximum: 50 }
  
  def average_response_time
    answered_requests = MentorAsk.answered_requests_with(self)
    average_response_in_days(answered_requests)
  end

  def median_response_time
    answered_requests = MentorAsk.answered_requests_with(self)
    median_response_in_days(answered_requests)
  end

end
