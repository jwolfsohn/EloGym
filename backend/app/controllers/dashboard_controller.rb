class DashboardController < ApplicationController
  before_action :require_login

  def index
    @user = current_user
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @training_day = current_user.current_training_day

    if @training_day
      # Show the same 3 exercises for the day, deterministically
      @exercises = @training_day.exercises.order(:id).limit(3)
      @completed_today = current_user.completed_exercises.where(completed_at: @date).pluck(:exercise_id)
    else
      @exercises = []
      @completed_today = []
    end
  end
end
