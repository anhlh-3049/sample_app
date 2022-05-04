class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.user.email_regex

  attr_accessor :remember_token

  validates :name, presence: true
  validates :email, presence: true,
            length: {maximum: Settings.user.email.max_length},
            format: {with: VALID_EMAIL_REGEX}
  validates :password, presence: true,
            length: {minimum: Settings.user.password.min},
            allow_nil: true

  before_save :downcase_email

  has_secure_password

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    BCrypt::Password.new (remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  private

  def downcase_email
    email.downcase!
  end
end
