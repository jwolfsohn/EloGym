class UserSplit < ApplicationRecord
  belongs_to :user
  belongs_to :split, class_name: "TrainingSplit"

  validates :user_id, uniqueness: { scope: :split_id }
end
