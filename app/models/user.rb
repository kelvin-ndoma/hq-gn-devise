class User < ApplicationRecord
  # Include default devise modules

  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :recoverable, :registerable, :validatable, :rememberable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  # Validations
  validates :first_name, presence: true, length: { maximum: 50 }, unless: :password_reset?
  validates :last_name, presence: true, length: { maximum: 50 }, unless: :password_reset?
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?
  validates :bio, length: { maximum: 500 }, allow_blank: true
  validates :city, length: { maximum: 100 }, allow_blank: true
  validates :country, length: { maximum: 100 }, allow_blank: true

  # Callbacks
  before_validation :normalize_email

  # Methods
  def password_required?
    new_record? || password.present?
  end


  # Add this method to check if this is a password reset request
  def password_reset?
    self.reset_password_token.present?
  end

  def normalize_email
    self.email = email.strip.downcase if email.present?
  end
end
