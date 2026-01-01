class TrainingDay < ApplicationRecord
  belongs_to :split, class_name: "TrainingSplit"
  has_many :day_exercises, foreign_key: "day_id", dependent: :destroy
  has_many :exercises, through: :day_exercises

  validates :day_name, presence: true
  validates :day_order, presence: true, uniqueness: { scope: :split_id }
end
