class Answer < ActiveRecord::Base
  belongs_to :ask
  after_create :answer
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
    length: {maximum: 256}

  private

  def answer
    ask.answered = true
    ask.save
    send_introduction
  end

  def send_introduction
    NotificationMailer.create_response(self.email, ask.email).deliver
  end
end
