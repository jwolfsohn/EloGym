module Api
  module Matchmaking
    class BattleController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authorize_api

      # POST /api/matchmaking/battle/challenge
      def challenge
        opponent = User.find_by(id: params[:opponent_id])

        if opponent.nil?
          render json: { error: "User not found" }, status: :not_found
          return
        end

        if current_user.id == opponent.id
          render json: { error: "Cannot challenge yourself" }, status: :unprocessable_entity
          return
        end

        battle = Battle.create(
          challenger: current_user,
          opponent: opponent,
          status: "pending"
        )

        if battle.persisted?
          render json: {
            message: "Battle challenge sent!",
            battle: {
              id: battle.id,
              challenger: current_user.username,
              opponent: opponent.username,
              status: battle.status
            }
          }
        else
          render json: { errors: battle.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end
