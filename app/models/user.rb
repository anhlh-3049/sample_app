class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.user.email_regex

  validates :name, presence: true
  validates :email, presence: true,
            length: {maximum: Settings.user.email.max_length},
            format: {with: VALID_EMAIL_REGEX}

  before_save :downcase_email

  has_secure_password
  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end
  end

  private

  def downcase_email
    email.downcase!
  end
end
