class FeedbackMailer < ActionMailer::Base
  default from: 'mentors@hatsnpants.com'

  def solicit_feedback
    answers_to_solicit = Answer.where("created_at > ? AND created_at < ?",
                         1.month.ago - 1.day, 1.month.ago + 1.day)
    answers_to_solicit.each do |answer|
      solicit_feedback_from_mentor(answer)
      solicit_feedback_from_mentee(answer.ask)
    end
  end

  def solicit_feedback_from_mentor(mentor)
    mail to: mentor.email, subject: 'How has your mentoring gone?'
  end

  def solicit_feedback_from_mentee(mentee)
    mail to: mentee.email, subject: 'How have your mentoring sessions gone?'
  end

end
