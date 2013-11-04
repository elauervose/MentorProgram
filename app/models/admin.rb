class Admin < ActiveRecord::Base
  include Emailable
  before_create :create_remember_token
  has_secure_password
  validates :email, uniqueness: { case_sensitive: false }

  def Admin.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def Admin.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = Admin.encrypt(Admin.new_remember_token)
    end
end
