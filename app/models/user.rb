class User < ActiveRecord::Base

  attr_accessor :remember_token

  has_many :rooms
  has_many :chats
  has_many :tenancies, foreign_key: "user_id", class_name: "Tenant"

  VALID_USER_REGEX = /\A[a-zA-Z0-9]+\z/
  validates :username, presence: true,
                       length: {minimum: 2, maximum: 15 },
                       format: { with: VALID_USER_REGEX },
                       uniqueness: { case_sensitive: false }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, allow_blank: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates_length_of :name, within: 2..15 #, too_long: 'pick a shorter name', too_short: 'pick a longer name'

  has_secure_password

  def User.digest(string)
     cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                   BCrypt::Engine.cost
     BCrypt::Password.create(string, cost: cost)
   end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

end
