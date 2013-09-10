class Answer < ActiveRecord::Base
  belongs_to :ask
  after_create :answer_request
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
    length: {maximum: 256}

  def self.solicit_feedback
    answers_to_solicit = Answer.month_ago
    answers_to_solicit.each do |answer|
      if answer.ask.type == 'MentorAsk'
        FeedbackMailer.solicit_feedback_from_mentor(answer).deliver
        FeedbackMailer.solicit_feedback_from_mentee(answer.ask).deliver
      end
    end
  end

  scope :month_ago, -> { where("created_at > ? AND created_at < ?",
                                1.month.ago - 1.day, 1.month.ago + 1.day) }

  private

  def answer_request
    ask.answered = true
    ask.save
    send_introduction
  end

  def send_introduction
    Introduction.new(self.ask).send_introduction
  end

end
