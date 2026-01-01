class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: -> { request.format.json? }

  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= begin
      if session[:user_id]
        User.find_by(id: session[:user_id])
      elsif request.headers["Authorization"].present?
        authenticate_api_user
      end
    end
  end

  def authenticate_api_user
    token = request.headers["Authorization"]&.split(" ")&.last
    return nil unless token

    decoded = JsonWebToken.decode(token)
    return nil unless decoded

    User.find_by(id: decoded[:user_id])
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless logged_in?
      if request.format.json?
        render json: { error: "Unauthorized" }, status: :unauthorized
      else
        redirect_to login_path, alert: "Please log in to continue"
      end
    end
  end

  def authorize_api
    unless current_user
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
