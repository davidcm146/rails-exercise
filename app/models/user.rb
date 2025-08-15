# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar
  has_many :jobs, foreign_key: :created_by_id, dependent: :destroy, inverse_of: :created_by

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :full_name, presence: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  private

  def password_required?
    new_record? || password.present?
  end
end
