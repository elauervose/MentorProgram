class Answer < ActiveRecord::Base
  belongs_to :ask
  after_create :answer

  private

  def answer
    ask.answered = true
    ask.save
  end
end
