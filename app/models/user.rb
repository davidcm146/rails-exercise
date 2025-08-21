# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar
  has_many :jobs, foreign_key: :created_by_id, dependent: :destroy, inverse_of: :created_by
end
