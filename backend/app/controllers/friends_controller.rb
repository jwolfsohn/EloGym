class FriendsController < ApplicationController
  before_action :require_login

  def create
    friend_user = User.find(params[:friend_id])
    
    # Check if friendship already exists
    existing_friendship = Friend.find_by(user: current_user, friend: friend_user) ||
                         Friend.find_by(user: friend_user, friend: current_user)
    
    if existing_friendship
      redirect_to battles_path, alert: "You are already friends or have a pending request."
    else
      @friendship = current_user.friends.create(friend: friend_user, status: "accepted")
      # Create reciprocal friendship
      Friend.create(user: friend_user, friend: current_user, status: "accepted")
      
      redirect_to battles_path, notice: "#{friend_user.username} added as friend!"
    end
  end

  def destroy
    friendship = current_user.friends.find(params[:id])
    friend_user = friendship.friend
    
    # Remove both directions of friendship
    Friend.where(user: current_user, friend: friend_user).destroy_all
    Friend.where(user: friend_user, friend: current_user).destroy_all
    
    redirect_to battles_path, notice: "Friend removed."
  end
end
