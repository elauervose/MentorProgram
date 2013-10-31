class ValidationMailer < ActionMailer::Base
  default from: 'mentors@hatsnpants.com'

  def request_validation(ask)
    @ask = ask
    mail to: ask.email, subject: 'Please validate your request'
  end

end
