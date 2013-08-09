class NotificationMailer < ActionMailer::Base
  default from: 'admin@example.com'

  def create_response(mentor, mentee)
    mail to: [mentor,mentee], subject: 'Mentor and Mentee Introduction'
  end
end

