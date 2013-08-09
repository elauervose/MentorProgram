class Answer < ActiveRecord::Base
  belongs_to :ask
  after_create :answer

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
