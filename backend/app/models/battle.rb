class Battle < ApplicationRecord
  belongs_to :challenger, class_name: "User"
  belongs_to :opponent, class_name: "User"
  belongs_to :winner, class_name: "User", optional: true

  validates :status, inclusion: { in: %w[pending completed declined] }

  scope :pending, -> { where(status: "pending") }
  scope :completed, -> { where(status: "completed") }

  def complete_battle(winner_user)
    return false unless pending?

    self.winner = winner_user
    self.status = "completed"

    # Calculate points
    base_points = 50
    self.points_gained = base_points
    self.points_lost = base_points / 2

    # Award points to winner
    winner.increment!(:total_points, points_gained)

    # Deduct points from loser
    loser = winner == challenger ? opponent : challenger
    loser.decrement!(:total_points, [points_lost, loser.total_points].min)

    save
  end

  private

  def pending?
    status == "pending"
  end
end
