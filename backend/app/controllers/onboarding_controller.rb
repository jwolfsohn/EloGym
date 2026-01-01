class OnboardingController < ApplicationController
  before_action :require_login

  def index
    redirect_to onboarding_welcome_path
  end

  def welcome
  end

  def split
    @splits = TrainingSplit.all
  end

  def save_split
    split = TrainingSplit.find_by(id: params[:split_id])

    if split
      current_user.user_splits.destroy_all
      current_user.user_splits.create(split: split)
      redirect_to onboarding_stats_path, notice: "Training split selected!"
    else
      redirect_to onboarding_split_path, alert: "Please select a valid split"
    end
  end

  def stats
  end

  def save_stats
    if params[:bodyweight].present?
      current_user.update(bodyweight: params[:bodyweight])
      redirect_to dashboard_path, notice: "Onboarding complete!"
    else
      flash.now[:alert] = "Please enter your bodyweight"
      render :stats, status: :unprocessable_entity
    end
  end
end
