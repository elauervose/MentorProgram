class Admin < ActiveRecord::Base
  has_secure_password  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
    length: { maximum: 256}, uniqueness: { case_sensitive: false }
end
