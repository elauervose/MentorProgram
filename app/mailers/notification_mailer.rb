class NotificationMailer < ActionMailer::Base
  default from: 'mentors@hatsnpants.com'

  def introduce_mentor_to_mentee(ask)
    @mentor = ask.answer
    mail to: ask.email,
      subject: 'Your request for a mentor has been answered'
  end

  def introduce_mentee_to_mentor(ask)
    @mentee = ask
    mail to: ask.answer.email,
      subject: 'Thank your for becoming a mentor'
  end

end

