class Battle < ApplicationRecord
  belongs_to :challenger, class_name: "User"
  belongs_to :opponent, class_name: "User"
  belongs_to :winner, class_name: "User", optional: true

  validates :status, inclusion: { in: %w[pending completed declined] }

  scope :pending, -> { where(status: "pending") }
  scope :completed, -> { where(status: "completed") }

  def calculate_winner
    return nil unless challenger_stats_submitted? && opponent_stats_submitted?

    challenger_wins = 0
    opponent_wins = 0

    # Compare bench press
    if challenger_bench_press > opponent_bench_press
      challenger_wins += 1
    elsif opponent_bench_press > challenger_bench_press
      opponent_wins += 1
    end

    # Compare deadlift
    if challenger_deadlift > opponent_deadlift
      challenger_wins += 1
    elsif opponent_deadlift > challenger_deadlift
      opponent_wins += 1
    end

    # Compare pushups
    if challenger_pushups > opponent_pushups
      challenger_wins += 1
    elsif opponent_pushups > challenger_pushups
      opponent_wins += 1
    end

    # Winner needs at least 2/3 categories
    if challenger_wins >= 2
      challenger
    elsif opponent_wins >= 2
      opponent
    else
      nil # Draw
    end
  end

  def complete_battle!
    return false unless pending? && challenger_stats_submitted? && opponent_stats_submitted?

    winner_user = calculate_winner
    self.winner = winner_user
    self.status = "completed"

    if winner_user
      # Calculate points based on rank difference
      base_points = 50
      self.points_gained = base_points
      self.points_lost = base_points / 2

      # Award points to winner
      winner_user.increment!(:total_points, points_gained)

      # Deduct points from loser
      loser = winner_user == challenger ? opponent : challenger
      loser.decrement!(:total_points, [points_lost, loser.total_points].min)
    end

    save
  end

  def challenger_stats_submitted?
    challenger_bench_press.present? && challenger_deadlift.present? && challenger_pushups.present?
  end

  def opponent_stats_submitted?
    opponent_bench_press.present? && opponent_deadlift.present? && opponent_pushups.present?
  end

  private

  def pending?
    status == "pending"
  end
end
