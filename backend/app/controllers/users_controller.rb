class UsersController < ApplicationController
  before_action :require_login

  def show
    @user = User.find(params[:id])
    @stats = {
      total_points: @user.total_points,
      rank: @user.rank,
      bodyweight: @user.bodyweight,
      friends_count: @user.all_friends.count,
      completed_exercises: @user.completed_exercises.count
    }
  end
end
