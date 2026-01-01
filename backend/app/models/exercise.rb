class Exercise < ApplicationRecord
  has_many :day_exercises, dependent: :destroy
  has_many :training_days, through: :day_exercises, source: :day
  has_many :completed_exercises, dependent: :destroy
  has_many :users, through: :completed_exercises

  validates :name, presence: true

  # Base weight multipliers for exercises
  BASE_MULTIPLIERS = {
    "Bench Press" => 0.75,
    "Squat" => 0.85,
    "Deadlift" => 1.0,
    "Overhead Press" => 0.45,
    "Barbell Row" => 0.65,
    "Bicep Curl" => 0.15,
    "Tricep Extension" => 0.15,
    "Lateral Raise" => 0.1,
    "Front Raise" => 0.1,
    "Leg Curl" => 0.3,
    "Leg Extension" => 0.3,
    "Calf Raise" => 0.5
  }.freeze

  def base_multiplier
    BASE_MULTIPLIERS[name] || 0.3
  end

  def target_weight_for_user(user)
    return 0 unless user.bodyweight

    raw_weight = user.bodyweight * base_multiplier * user.rank_multiplier
    (raw_weight / 5.0).round * 5
  end
end
