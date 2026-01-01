class DayExercise < ApplicationRecord
  belongs_to :day, class_name: "TrainingDay"
  belongs_to :exercise

  validates :day_id, uniqueness: { scope: :exercise_id }
end
