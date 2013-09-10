class Introduction

  def initialize(ask)
    @ask = ask
  end

  def send_introduction
    if @ask.type == "MentorAsk"
      send_mentoring_introduction
    else
      send_pairing_introduction
    end
  end

  private

  def send_mentoring_introduction
    NotificationMailer.introduce_mentee_to_mentor(@ask).deliver
    NotificationMailer.introduce_mentor_to_mentee(@ask).deliver
  end

  def send_pairing_introduction
    NotificationMailer.introduce_pair_requester_to_answerer(@ask).deliver
    NotificationMailer.introduce_pair_answerer_to_requester(@ask).deliver
  end
end
