class BattlesController < ApplicationController
  before_action :require_login

  def index
    @friends = current_user.all_friends
    @pending_battles = Battle.where(challenger: current_user).or(Battle.where(opponent: current_user)).pending
    @completed_battles = Battle.where(challenger: current_user).or(Battle.where(opponent: current_user)).completed.limit(10)
  end
end
