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

  def introduce_pair_answerer_to_requester(ask)
    @pair_answerer = ask.answer
    mail to: ask.email, subject: 'Your pairing request has been answered'
  end

  def introduce_pair_requester_to_answerer(ask)
    @pair_requester = ask
    mail to: ask.answer.email, subject: 'How to contact your pairing partner'
  end

end

