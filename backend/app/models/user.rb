class User < ApplicationRecord
  has_secure_password

  # Associations
  has_many :user_splits, dependent: :destroy
  has_many :training_splits, through: :user_splits, source: :split
  has_many :completed_exercises, dependent: :destroy
  has_many :exercises, through: :completed_exercises

  # Friends associations
  has_many :friends, dependent: :destroy
  has_many :friend_users, through: :friends, source: :friend
  has_many :inverse_friends, class_name: "Friend", foreign_key: "friend_id", dependent: :destroy
  has_many :inverse_friend_users, through: :inverse_friends, source: :user

  # Battles
  has_many :challenged_battles, class_name: "Battle", foreign_key: "challenger_id", dependent: :destroy
  has_many :opponent_battles, class_name: "Battle", foreign_key: "opponent_id", dependent: :destroy

  # Validations
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  # Rank calculation based on total_points
  def rank
    case total_points
    when 0..499
      "E"
    when 500..999
      "D"
    when 1000..1999
      "C"
    when 2000..3499
      "B"
    when 3500..5499
      "A"
    else
      "S"
    end
  end

  def rank_multiplier
    case rank
    when "S" then 2.2
    when "A" then 1.8
    when "B" then 1.6
    when "C" then 1.25
    when "D" then 1.0
    when "E" then 0.5
    else 1.0
    end
  end

  # Get current training day based on completed exercises
  def current_training_day
    return nil unless training_splits.any?

    split = training_splits.first
    days = split.training_days.order(:day_order)
    return days.first if days.empty?

    # Count completed exercises to determine rotation
    completed_count = completed_exercises.count
    day_index = completed_count % days.count
    days[day_index]
  end

  # Get all friends (both directions)
  def all_friends
    accepted_friends = friends.where(status: "accepted").includes(:friend)
    accepted_inverse_friends = inverse_friends.where(status: "accepted").includes(:user)

    friend_ids = accepted_friends.pluck(:friend_id) + accepted_inverse_friends.pluck(:user_id)
    User.where(id: friend_ids)
  end
end
