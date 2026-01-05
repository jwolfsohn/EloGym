class ExercisesController < ApplicationController
  before_action :require_login

  def complete
    exercise = Exercise.find(params[:id])
    
    # Check if already completed today
    if current_user.completed_exercises.where(exercise: exercise, completed_at: Date.today).exists?
      redirect_back(fallback_location: dashboard_path, alert: "Exercise already completed today.")
      return
    end

    # Create completion record
    current_user.completed_exercises.create!(
      exercise: exercise,
      completed_at: Date.today
    )

    # Award points (e.g., 1 point per completion)
    # Using increment! to atomicity update the counter
    current_user.increment!(:total_points, 1)

    redirect_back(fallback_location: dashboard_path, notice: "Exercise completed! +1 Point")
  end
end
