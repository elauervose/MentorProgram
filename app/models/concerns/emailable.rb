module Emailable
  extend ActiveSupport::Concern

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  included do
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
      length: { maximum: 256}
  end

end
