# frozen_string_literal: true

class Job < ApplicationRecord
  before_create :generate_share_link
  belongs_to :created_by, class_name: 'User', inverse_of: :jobs
  validates :title, :salary_from, :salary_to, presence: true
  enum status: { draft: 0, published: 1 }, _default: :draft

  private

  def generate_share_link
    self.share_link = SecureRandom.hex(10)
  end
end
