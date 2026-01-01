class TrainingSplit < ApplicationRecord
  has_many :user_splits, foreign_key: "split_id", dependent: :destroy
  has_many :users, through: :user_splits
  has_many :training_days, foreign_key: "split_id", dependent: :destroy

  validates :name, presence: true
end
