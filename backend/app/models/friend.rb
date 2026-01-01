class Friend < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validates :user_id, uniqueness: { scope: :friend_id }
  validates :status, inclusion: { in: %w[pending accepted declined] }

  scope :pending, -> { where(status: "pending") }
  scope :accepted, -> { where(status: "accepted") }
end
