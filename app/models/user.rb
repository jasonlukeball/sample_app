class User < ActiveRecord::Base

  attr_accessor :remember_token, :activation_token

  # Save email addresses to db in downcase (references the private method below)
  before_save :downcase_email

  # Before user is created, we need to create an activation digest (references the private method below)
  before_create :create_activation_digest

  # name must not be empty, and must be less than 50 characters
  validates :name,  presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # email must not be empty, must be less than 255 characters & is a valid email via the regular expression
  validates :email, presence: true, length: { maximum: 255 },
  format: { with: VALID_EMAIL_REGEX },
  # email validation ignores case sensitivity
  uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password,  presence: true, length: { minimum: 6 }, allow_blank: true


  # Returns the hash digest of a given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions
  def remember
    self.remember_token = User.new_token
    self.update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Forgets a user.
  def forget
    #self.update_attribute(:remember_digest, nil )
  end

  # Returns true if the given token matches the digest
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  private

    # Converts email to all lower case
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest
    def create_activation_digest
      self.activation_token   = User.new_token
      self.activation_digest  = User.digest(activation_token)
    end

end