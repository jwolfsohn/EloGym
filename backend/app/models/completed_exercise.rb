class CompletedExercise < ApplicationRecord
  belongs_to :user
  belongs_to :exercise

  validates :completed_at, presence: true

  # after_create :award_points

  private

  def award_points
    # Award points based on rank
    points = case user.rank
    when "S" then 100
    when "A" then 80
    when "B" then 60
    when "C" then 40
    when "D" then 20
    else 10
    end

    user.increment!(:total_points, points)
  end
end
