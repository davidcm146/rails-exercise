class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :full_name, presence: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  private

  def email_required?
    new_record? || email.present?
  end

  def password_required?
    new_record? || password.present?
  end
end
