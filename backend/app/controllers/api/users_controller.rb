module Api
  class UsersController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authorize_api, except: [:signup, :login]

    # POST /api/users/signup
    def signup
      user = User.new(signup_params)

      if user.save
        token = JsonWebToken.encode(user_id: user.id)
        render json: {
          token: token,
          user: user_response(user)
        }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # POST /api/users/login
    def login
      user = User.find_by(email: params[:email])

      if user&.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: user.id)
        render json: {
          token: token,
          user: user_response(user)
        }
      else
        render json: { error: "Invalid email or password" }, status: :unauthorized
      end
    end

    # GET /api/users/profile
    def profile
      render json: { user: user_response(current_user) }
    end

    # PATCH /api/users/split
    def split
      split = TrainingSplit.find_by(name: params[:split_name])

      if split.nil?
        render json: { error: "Invalid split" }, status: :unprocessable_entity
        return
      end

      current_user.user_splits.destroy_all
      current_user.user_splits.create(split: split)

      render json: { message: "Split updated successfully", split: split.name }
    end

    # POST /api/users/starting-stats
    def starting_stats
      if params[:bodyweight].present?
        current_user.update(bodyweight: params[:bodyweight])
      end

      # You can add logic to store max lifts if needed
      render json: { message: "Stats saved successfully" }
    end

    # GET /api/users/daily-exercises
    def daily_exercises
      training_day = current_user.current_training_day

      if training_day.nil?
        render json: { exercises: [], message: "No training split assigned" }
        return
      end

      # Get 3 random exercises from the current training day
      exercises = training_day.exercises.sample(3)

      exercises_data = exercises.map do |exercise|
        {
          id: exercise.id,
          name: exercise.name,
          muscle_group: exercise.muscle_group,
          equipment: exercise.equipment,
          target_weight: exercise.target_weight_for_user(current_user),
          sets: 3,
          reps: 5
        }
      end

      render json: {
        day_name: training_day.day_name,
        exercises: exercises_data
      }
    end

    # POST /api/users/complete-exercise
    def complete_exercise
      exercise = Exercise.find_by(id: params[:exercise_id])

      if exercise.nil?
        render json: { error: "Exercise not found" }, status: :not_found
        return
      end

      completed = current_user.completed_exercises.create(
        exercise: exercise,
        completed_at: Date.today
      )

      if completed.persisted?
        render json: {
          message: "Exercise completed!",
          points_earned: points_for_rank(current_user.rank),
          total_points: current_user.reload.total_points,
          rank: current_user.rank
        }
      else
        render json: { errors: completed.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def signup_params
      params.permit(:username, :email, :password, :password_confirmation)
    end

    def user_response(user)
      {
        id: user.id,
        username: user.username,
        email: user.email,
        total_points: user.total_points,
        rank: user.rank,
        bodyweight: user.bodyweight
      }
    end

    def points_for_rank(rank)
      case rank
      when "S" then 100
      when "A" then 80
      when "B" then 60
      when "C" then 40
      when "D" then 20
      else 10
      end
    end
  end
end
