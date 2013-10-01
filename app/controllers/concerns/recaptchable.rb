module Recaptchable

  def valid_recaptcha?
    verify_recaptcha(model: @ask,
                     message: "Captcha verification failed, please try again")
  end

end
