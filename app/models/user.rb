class User < ActiveRecord::Base

  # Save email addresses to db in downcase
  before_save { self.email = email.downcase }

  # name must not be empty, and must be less than 50 characters
  validates :name,  presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # email must not be empty, must be less than 255 characters & is a valid email via the regular expression
  validates :email, presence: true, length: { maximum: 255 },
  format: { with: VALID_EMAIL_REGEX },
  # email validation ignores case sensitivity
  uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password,  presence: true, length: { minimum: 6 }
end