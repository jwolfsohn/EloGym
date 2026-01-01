module Api
  class MatchmakingController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authorize_api

    # GET /api/matchmaking/friends
    def friends
      friends = current_user.all_friends

      friends_data = friends.map do |friend|
        {
          id: friend.id,
          username: friend.username,
          rank: friend.rank,
          total_points: friend.total_points
        }
      end

      render json: { friends: friends_data }
    end

    # POST /api/matchmaking/friends/add
    def add
      friend = User.find_by(id: params[:friend_id])

      if friend.nil?
        render json: { error: "User not found" }, status: :not_found
        return
      end

      if current_user.id == friend.id
        render json: { error: "Cannot add yourself as a friend" }, status: :unprocessable_entity
        return
      end

      # Check if friendship already exists
      existing = Friend.find_by(user: current_user, friend: friend) ||
                 Friend.find_by(user: friend, friend: current_user)

      if existing
        render json: { error: "Friend request already exists" }, status: :unprocessable_entity
        return
      end

      friend_record = current_user.friends.create(friend: friend, status: "accepted")

      if friend_record.persisted?
        render json: { message: "Friend added successfully" }
      else
        render json: { errors: friend_record.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # GET /api/matchmaking/search
    def search
      query = params[:query].to_s.strip

      if query.blank?
        render json: { users: [] }
        return
      end

      users = User.where("username ILIKE ?", "%#{query}%")
                  .where.not(id: current_user.id)
                  .limit(10)

      users_data = users.map do |user|
        {
          id: user.id,
          username: user.username,
          rank: user.rank,
          total_points: user.total_points
        }
      end

      render json: { users: users_data }
    end
  end
end
