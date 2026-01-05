class BattlesController < ApplicationController
  before_action :require_login
  before_action :set_battle, only: [:show, :respond, :submit_response]

  def index
    @friends = current_user.all_friends
    @pending_battles = Battle.where(challenger: current_user).or(Battle.where(opponent: current_user)).pending
    @completed_battles = Battle.where(challenger: current_user).or(Battle.where(opponent: current_user)).completed.order(updated_at: :desc).limit(10)

    # Search for users
    if params[:query].present?
      @search_results = User.where("username LIKE ?", "%#{params[:query]}%")
                            .where.not(id: current_user.id)
                            .limit(10)
    else
      @search_results = []
    end
  end

  def new
    @opponent = User.find(params[:opponent_id])
    @battle = Battle.new(opponent: @opponent, challenger: current_user)
  end

  def create
    @opponent = User.find(params[:opponent_id])
    @battle = Battle.new(
      challenger: current_user,
      opponent: @opponent,
      challenger_bench_press: params[:bench_press],
      challenger_deadlift: params[:deadlift],
      challenger_pushups: params[:pushups]
    )

    if @battle.save
      redirect_to battles_path, notice: "Battle challenge sent to #{@opponent.username}!"
    else
      render :new
    end
  end

  def show
    # Show battle details/results
  end

  def respond
    # Only opponent can respond
    unless @battle.opponent == current_user
      redirect_to battles_path, alert: "You can only respond to battles where you're the opponent."
      return
    end

    if @battle.opponent_stats_submitted?
      redirect_to battles_path, alert: "You have already responded to this battle."
    end
  end

  def submit_response
    unless @battle.opponent == current_user
      redirect_to battles_path, alert: "You can only respond to battles where you're the opponent."
      return
    end

    @battle.opponent_bench_press = params[:bench_press]
    @battle.opponent_deadlift = params[:deadlift]
    @battle.opponent_pushups = params[:pushups]

    if @battle.save
      @battle.complete_battle!
      redirect_to battle_path(@battle), notice: "Battle completed! Check the results."
    else
      render :respond
    end
  end

  private

  def set_battle
    @battle = Battle.find(params[:id])
  end
end
